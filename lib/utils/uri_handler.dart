import 'package:pass_emploi_app/utils/platform.dart';

class UriHandler {
  Uri phoneUri(String phone) => Uri.parse("tel:$phone");

  Uri mailUri({required String to, required String subject}) {
    return Uri(
      scheme: 'mailto',
      path: to,
      query: _encodeQueryParameters({'subject': subject}),
    );
  }

  Uri mapsUri(String address, Platform platform) {
    if (platform == Platform.ANDROID) {
      return Uri(scheme: 'geo', path: '0,0', query: _encodeQueryParameters({'q': address}));
    } else {
      return Uri.https('maps.apple.com', '/maps', {'q': address});
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
