import 'package:url_launcher/url_launcher.dart';

class MailHandler {
  static Future<bool> sendEmail({required String email, required String subject, required String body}) async {
    final mailUrl = _getEmailString(email: email, subject: subject, body: body);
    try {
      // ignore: ban-name
      await launchUrl(Uri.parse(mailUrl), mode: LaunchMode.externalApplication);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String _getEmailString({required String email, required String subject, required String body}) {
    final Uri emailReportUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{'subject': subject, 'body': body}),
    );
    return emailReportUri.toString();
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
