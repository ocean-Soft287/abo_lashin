import 'package:url_launcher/url_launcher.dart';

class AppLauncher {
  AppLauncher._();

  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $phone');
    }
  }

  static Future<void> openWhatsApp({
    required String phone,
    required String message,
  }) async {
    final uri = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch WhatsApp');
    }
  }

  static Future<void> sendEmail({
    required String email,
    String subject = '',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body},
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch Email');
    }
  }

  static Future<void> openMap(String url) async {
    await openUrl(url);
  }
}
