import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class TextWithClickableLinks extends StatelessWidget {
  final String content;
  final TextStyle style;
  final TextStyle? linkStyle;

  TextWithClickableLinks(this.content, {required this.style, this.linkStyle});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: content,
      style: style,
      linkStyle: linkStyle ?? TextStyles.externalLink,
      onOpen: (link) {
        final String baseUrl = Uri.parse(link.url).origin;
        MatomoTracker.trackScreenWithName(baseUrl, baseUrl);
        launch(link.url);
      },
      options: LinkifyOptions(
        humanize: true,
        looseUrl: true,
        defaultToHttps: true,
      ),
    );
  }
}
