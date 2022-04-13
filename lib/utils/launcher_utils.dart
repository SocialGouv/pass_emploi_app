import 'package:url_launcher/url_launcher.dart';

void launchExternalUrl(String url) {
  launch(url, forceSafariVC: false);
}
