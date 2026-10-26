import 'package:abolashin/core/services/app_update/app_update_policy.dart';
import 'package:abolashin/core/services/app_update/app_update_service.dart';
import 'package:abolashin/core/services/app_update/app_update_view.dart';
import 'package:abolashin/core/services/external_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpTestEnvironment);

  group('AppUpdatePolicy.decide', () {
    test('no minimum configured: never mandatory', () {
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 4,
          minSupportedBuild: 0,
          store: StoreUpdateStatus.available,
        ),
        AppUpdateType.optional,
      );
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 4,
          minSupportedBuild: 0,
          store: StoreUpdateStatus.unknown,
        ),
        AppUpdateType.none,
      );
    });

    test('below the minimum is mandatory unless Play says nothing newer', () {
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 4,
          minSupportedBuild: 5,
          store: StoreUpdateStatus.available,
        ),
        AppUpdateType.mandatory,
      );
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 4,
          minSupportedBuild: 5,
          store: StoreUpdateStatus.unknown,
        ),
        AppUpdateType.mandatory,
      );
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 4,
          minSupportedBuild: 5,
          store: StoreUpdateStatus.notAvailable,
        ),
        AppUpdateType.none,
      );
    });

    test('at or above the minimum is never mandatory', () {
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 5,
          minSupportedBuild: 5,
          store: StoreUpdateStatus.notAvailable,
        ),
        AppUpdateType.none,
      );
    });

    test('unknown installed build never forces an update', () {
      expect(
        AppUpdatePolicy.decide(
          installedBuild: 0,
          minSupportedBuild: 5,
          store: StoreUpdateStatus.unknown,
        ),
        AppUpdateType.none,
      );
    });
  });

  group('optional prompt throttling', () {
    final now = DateTime(2026, 10, 20, 12);

    test('snoozed build is hidden for the snooze period only', () {
      bool show(DateTime at, {int? code = 6}) =>
          AppUpdatePolicy.shouldShowOptional(
            availableVersionCode: code,
            dismissedVersionCode: 6,
            dismissedAt: at,
            now: now,
          );
      expect(show(now.subtract(const Duration(days: 1))), isFalse);
      expect(show(now.subtract(AppUpdatePolicy.snooze)), isTrue);
      expect(show(now.subtract(const Duration(hours: 1)), code: 7), isTrue);
    });

    test('shown at most once per session, and "Later" is remembered', () async {
      await resetTestServices();
      AppUpdateService.resetSession();
      const update = AppUpdateCheck(
        type: AppUpdateType.optional,
        availableVersionCode: 6,
      );

      AppUpdateService.setPendingOptional(update);
      expect(AppUpdateService.takePendingOptional(now: now), same(update));
      AppUpdateService.setPendingOptional(update);
      expect(AppUpdateService.takePendingOptional(now: now), isNull);

      await AppUpdateService.snooze(update);
      AppUpdateService.resetSession();
      AppUpdateService.setPendingOptional(update);
      expect(AppUpdateService.takePendingOptional(), isNull);
    });

    test('mandatory/none results are never queued as optional', () {
      AppUpdateService.resetSession();
      AppUpdateService.setPendingOptional(
        const AppUpdateCheck(type: AppUpdateType.mandatory),
      );
      expect(AppUpdateService.takePendingOptional(), isNull);
    });
  });

  test('a failing or slow check resolves to "no update"', () async {
    final original = AppUpdateService.checker;
    addTearDown(() => AppUpdateService.checker = original);

    AppUpdateService.checker = () async => throw Exception('offline');
    expect((await AppUpdateService.check()).type, AppUpdateType.none);
  });

  test('blank Remote Config text is treated as not configured', () {
    expect(AppUpdatePolicy.cleanText('  '), isNull);
    expect(AppUpdatePolicy.cleanText(null), isNull);
    expect(AppUpdatePolicy.cleanText(' 1.0.5 '), '1.0.5');
  });

  group('ForceUpdateScreen', () {
    setUp(usePhoneSize);
    tearDown(() => ExternalLinks.launcher = (u, m) => launchUrl(u, mode: m));

    testWidgets('cannot be dismissed and reports a store failure', (
      tester,
    ) async {
      final opened = <Uri>[];
      ExternalLinks.launcher = (uri, mode) async {
        opened.add(uri);
        return false;
      };
      await pumpTestApp(
        tester,
        const ForceUpdateScreen(
          result: AppUpdateCheck(
            type: AppUpdateType.mandatory,
            latestVersionName: '1.0.5',
          ),
        ),
        locale: const Locale('ar'),
        wrapInScaffold: false,
      );

      expect(find.text('يتوفر تحديث جديد'), findsOneWidget);
      expect(find.text('الإصدار 1.0.5'), findsOneWidget);
      expect(find.text('لاحقًا'), findsNothing);

      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);

      await tester.tap(find.text('تحديث الآن'));
      await tester.pumpAndSettle();
      expect(opened.map((u) => u.scheme), ['market', 'https']);
      expect(find.textContaining('تعذّر فتح متجر Google Play'), findsOneWidget);
    });

    testWidgets('optional card offers "Later" and hides empty notes', (
      tester,
    ) async {
      var later = 0;
      await pumpTestApp(
        tester,
        AppUpdateCard(
          result: const AppUpdateCheck(type: AppUpdateType.optional),
          onUpdate: () {},
          onLater: () => later++,
        ),
        locale: const Locale('en'),
      );
      expect(find.text('A New Update Is Available'), findsOneWidget);
      expect(find.textContaining('Version'), findsNothing);
      expect(find.text("What's new"), findsNothing);
      await tester.tap(find.text('Later'));
      expect(later, 1);
    });
  });
}
