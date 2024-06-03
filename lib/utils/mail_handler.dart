import 'package:pass_emploi_app/utils/launcher_utils.dart';

class MailHandler {
  static Future<bool> sendEmail({required String email, required String object, required String body}) async {
    final mailUrl = _getEmailString(email: email, object: object, body: body);
    try {
      final launched = await launchExternalUrl(mailUrl);
      return launched;
    } catch (e) {
      return false;
    }
  }

  static String _getEmailString({required String email, required String object, required String body}) {
    final Uri emailReportUri = Uri(
      scheme: 'mailto',
      path: email,
      query: _encodeQueryParameters(<String, String>{'subject': object, 'body': body}),
    );
    return emailReportUri.toString();
  }

  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
