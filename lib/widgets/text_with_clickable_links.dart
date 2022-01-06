import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TextWithClickableLinks extends StatelessWidget {
  final String content;
  final TextStyle style;

  TextWithClickableLinks(this.content, {required this.style});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      text: content,
      style: style,
      linkStyle: style,
      onOpen: (link) => launch(link.url),
      options: LinkifyOptions(
        humanize: true,
        looseUrl: true,
        defaultToHttps: true,
      ),
    );
  }
}
