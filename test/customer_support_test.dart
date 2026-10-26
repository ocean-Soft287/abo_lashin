import 'package:abolashin/features/menu/presentation/screen/about_app_screen.dart';
import 'package:abolashin/features/menu/presentation/screen/customer_support_screen.dart';
import 'package:abolashin/core/services/external_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setUpTestEnvironment);
  setUp(usePhoneSize);
  tearDown(() => ExternalLinks.launcher = (u, m) => launchUrl(u, mode: m));

  testWidgets('WhatsApp opens wa.me with the verified number', (tester) async {
    final opened = <Uri>[];
    ExternalLinks.launcher = (uri, mode) async {
      opened.add(uri);
      return true;
    };
    await pumpTestApp(
      tester,
      const CustomerSupportScreen(),
      locale: const Locale('ar'),
      wrapInScaffold: false,
    );
    expect(find.text('خدمة العملاء'), findsOneWidget);

    await tester.tap(find.text('واتساب'));
    await tester.pumpAndSettle();
    expect(opened.single.host, 'wa.me');
    expect(opened.single.path, '/201289064242');
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a failed launch shows a clear message and a copy fallback', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    ExternalLinks.launcher = (uri, mode) async => false;

    await pumpTestApp(
      tester,
      const CustomerSupportScreen(),
      locale: const Locale('ar'),
      wrapInScaffold: false,
    );
    await tester.tap(find.text('اتصل بنا'));
    await tester.pumpAndSettle();

    expect(find.textContaining('تعذّر فتح شاشة الاتصال'), findsOneWidget);
    await tester.tap(find.text('نسخ'));
    await tester.pumpAndSettle();
    expect(copied, '+201289064242');
  });

  testWidgets('email is shown as unavailable until configured', (tester) async {
    await pumpTestApp(
      tester,
      const CustomerSupportScreen(),
      locale: const Locale('en'),
      wrapInScaffold: false,
      textScale: 1.4,
    );
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Not available at the moment'),
      200,
    );
    expect(find.text('Not available at the moment'), findsOneWidget);
  });

  testWidgets('About shows the installed version from the platform', (
    tester,
  ) async {
    await pumpTestApp(
      tester,
      AboutAppScreen(
        packageInfo:
            () async => PackageInfo(
              appName: 'ابو لاشين',
              packageName: 'com.abolashine.theOne.abolashin',
              version: '1.0.4',
              buildNumber: '4',
            ),
      ),
      locale: const Locale('ar'),
      wrapInScaffold: false,
    );
    expect(find.text('الإصدار 1.0.4 (بناء 4)'), findsOneWidget);
    expect(find.text('قيّم التطبيق'), findsOneWidget);
    expect(find.text('The One System'), findsOneWidget);
    expect(find.text('غير متوفر حاليًا'), findsOneWidget);
  });
}
