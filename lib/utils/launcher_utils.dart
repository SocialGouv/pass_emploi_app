import 'package:url_launcher/url_launcher.dart';

void launchExternalUrl(String url) {
  // ignore: ban-name
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
