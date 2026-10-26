import 'package:abolashin/core/constants/app_config.dart';
import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/identity/user_identity.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/core/services/app_review_service.dart';
import 'package:abolashin/core/services/external_links.dart';
import 'helpers/test_app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await resetTestServices();
  });
  tearDown(() => ExternalLinks.launcher = (u, m) => launchUrl(u, mode: m));

  group('ExternalLinks', () {
    test('builds WhatsApp, dialer and email URIs from verified values', () {
      expect(
        ExternalLinks.whatsAppUri(
          AppConfig.supportWhatsApp,
          message: 'مرحبا',
        ).toString(),
        'https://wa.me/201289064242?text=%D9%85%D8%B1%D8%AD%D8%A8%D8%A7',
      );
      expect(
        ExternalLinks.dialerUri(AppConfig.supportPhone).toString(),
        'tel:+201289064242',
      );
      expect(
        ExternalLinks.emailUri('a@b.co', subject: 'طلب مساعدة').toString(),
        'mailto:a@b.co?subject=%D8%B7%D9%84%D8%A8%20%D9%85%D8%B3%D8%A7%D8%B9%D8%AF%D8%A9',
      );
    });

    test('reports failure when nothing can open the link', () async {
      ExternalLinks.launcher = (uri, mode) async => false;
      expect(await ExternalLinks.dial(AppConfig.supportPhone), isFalse);

      ExternalLinks.launcher =
          (uri, mode) async =>
              throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
      expect(await ExternalLinks.whatsApp(AppConfig.supportWhatsApp), isFalse);
      expect(await ExternalLinks.email('a@b.co'), isFalse);
      expect(await ExternalLinks.openUrl('not a url'), isFalse);
    });

    test('store listing falls back from the Play app to the web page', () async {
      final tried = <String>[];
      ExternalLinks.launcher = (uri, mode) async {
        tried.add(uri.toString());
        return uri.scheme == 'https';
      };
      expect(await ExternalLinks.openStoreListing(), isTrue);
      expect(tried, [AppConfig.playStoreMarketUrl, AppConfig.playStoreUrl]);
      expect(
        AppConfig.playStoreUrl,
        'https://play.google.com/store/apps/details?id=com.abolashine.theOne.abolashin',
      );
    });
  });

  group('AppReviewPolicy', () {
    final now = DateTime(2026, 10, 20);

    test('never on the first order, then at most once per cooldown', () {
      expect(
        AppReviewPolicy.shouldRequest(
          successfulOrders: 1,
          lastRequestedAt: null,
          now: now,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.shouldRequest(
          successfulOrders: 2,
          lastRequestedAt: null,
          now: now,
        ),
        isTrue,
      );
      expect(
        AppReviewPolicy.shouldRequest(
          successfulOrders: 9,
          lastRequestedAt: now.subtract(const Duration(days: 30)),
          now: now,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.shouldRequest(
          successfulOrders: 9,
          lastRequestedAt: now.subtract(AppReviewPolicy.cooldown),
          now: now,
        ),
        isTrue,
      );
    });
  });

  group('AppReviewService', () {
    const channel = MethodChannel('dev.britannio.in_app_review');
    late List<String> calls;

    setUp(() {
      calls = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            return call.method == 'isAvailable' ? true : null;
          });
    });
    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('asks once after the 2nd order, not again during cooldown', () async {
      final now = DateTime(2026, 10, 20);
      await AppReviewService.onOrderPlaced(now: now);
      expect(calls, isNot(contains('requestReview')));

      await AppReviewService.onOrderPlaced(now: now);
      expect(calls.where((c) => c == 'requestReview'), hasLength(1));

      await AppReviewService.onOrderPlaced(
        now: now.add(const Duration(days: 10)),
      );
      expect(calls.where((c) => c == 'requestReview'), hasLength(1));

      await AppReviewService.onOrderPlaced(
        now: now.add(AppReviewPolicy.cooldown),
      );
      expect(calls.where((c) => c == 'requestReview'), hasLength(2));
    });

    test('never throws into the order flow', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (call) async => throw PlatformException(code: 'boom'),
          );
      await AppReviewService.onOrderPlaced();
      await AppReviewService.onOrderPlaced();
    });
  });

  group('SessionManager', () {
    SessionManager session() => getIt<SessionManager>();

    test(
      'migrates a legacy signed-in customer once, keeping settings',
      () async {
        await resetTestServices({
          'customerID': 12,
          'customerName': 'محمد',
          'customerPhone': '0100',
          'changeLang': 'en',
        });

        expect(session().isAuthenticated, isTrue);
        expect(session().customerId, 12);
        expect(session().customerPhone, '0100');
        final prefs = getIt<SharedPreferences>();
        for (final key in ['customerID', 'customerName', 'customerPhone']) {
          expect(prefs.get(key), isNull, reason: key);
        }
        expect(getIt<AppPreferences>().languageCode, 'en');
      },
    );

    test(
      'guest session survives a restart and is never authenticated',
      () async {
        await resetTestServices();
        expect(session().hasSession, isFalse);

        await session().continueAsGuest();
        expect(session().isGuest, isTrue);
        expect(session().isAuthenticated, isFalse);
        expect(session().customerId, isNull);
        expect(session().customerPhone, isEmpty);

        await DI.reset();
        await DI.init(hivePath: testHivePath);
        expect(session().isGuest, isTrue);
      },
    );

    test('sign in replaces the guest session; sign out clears it', () async {
      await resetTestServices();
      await session().continueAsGuest();
      await session().signIn(const UserIdentity(customerId: 7, phone: '0111'));
      expect(session().isAuthenticated, isTrue);
      expect(session().isGuest, isFalse);

      await session().signOut();
      expect(session().hasSession, isFalse);
      expect(session().customerId, isNull);
    });
  });
}
