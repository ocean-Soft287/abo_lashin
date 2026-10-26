import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:abolashin/core/constants/app_config.dart';

typedef UriLauncher = Future<bool> Function(Uri uri, LaunchMode mode);

abstract class ExternalLinks {
  @visibleForTesting
  static UriLauncher launcher = (uri, mode) => launchUrl(uri, mode: mode);

  static Future<bool> open(
    Uri uri, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      return await launcher(uri, mode);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return Future.value(false);
    return open(uri);
  }

  static String _digits(String phone) => phone.replaceAll(RegExp(r'\D'), '');

  static Uri whatsAppUri(String phone, {String? message}) => Uri.https(
    'wa.me',
    '/${_digits(phone)}',
    message == null || message.isEmpty ? null : {'text': message},
  );

  static Uri dialerUri(String phone) =>
      Uri(scheme: 'tel', path: '+${_digits(phone)}');

  static Uri emailUri(String address, {String? subject}) => Uri(
    scheme: 'mailto',
    path: address,
    query:
        subject == null || subject.isEmpty
            ? null
            : 'subject=${Uri.encodeComponent(subject)}',
  );

  static Future<bool> whatsApp(String phone, {String? message}) =>
      open(whatsAppUri(phone, message: message));

  static Future<bool> dial(String phone) => open(dialerUri(phone));

  static Future<bool> email(String address, {String? subject}) =>
      open(emailUri(address, subject: subject));

  static Future<bool> openStoreListing() async {
    if (await open(Uri.parse(AppConfig.playStoreMarketUrl))) return true;
    return openUrl(AppConfig.playStoreUrl);
  }
}
