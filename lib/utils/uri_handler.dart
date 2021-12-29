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
    return Uri(
      scheme: platform == Platform.ANDROID ? 'geo' : 'https',
      path: platform == Platform.ANDROID ? '0,0' : '//maps.apple.com/maps',
      query: _encodeQueryParameters({'q': address}),
    );
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }
}
