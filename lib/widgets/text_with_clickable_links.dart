import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';

class TextWithClickableLinks extends StatelessWidget {
  final String content;
  final TextStyle style;

  TextWithClickableLinks(this.content, {required this.style});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: content,
      style: style,
      linkStyle: TextStyles.externalLink,
      onOpen: (link) {
        final String baseUrl = Uri.parse(link.url).origin;
        PassEmploiMatomoTracker.instance.trackOutlink(baseUrl);
        launchExternalUrl(link.url);
      },
      textScaleFactor: MediaQuery.of(context).textScaler.scale(1.0),
      options: LinkifyOptions(
        humanize: true,
        looseUrl: true,
        defaultToHttps: true,
      ),
    );
  }
}

class SelectableTextWithClickableLinks extends StatelessWidget {
  final String content;
  final TextStyle style;
  final TextStyle? linkStyle;

  SelectableTextWithClickableLinks(this.content, {required this.style, this.linkStyle});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      textScaleFactor: MediaQuery.of(context).textScaler.scale(1.0),
      text: content,
      style: style,
      linkStyle: linkStyle ?? TextStyles.externalLink,
      onOpen: (link) {
        final String baseUrl = Uri.parse(link.url).origin;
        PassEmploiMatomoTracker.instance.trackOutlink(baseUrl);
        launchExternalUrl(link.url);
      },
      options: LinkifyOptions(
        humanize: true,
        looseUrl: true,
        defaultToHttps: true,
      ),
    );
  }
}
