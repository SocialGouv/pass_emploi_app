import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class RechercheMessagePlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;

  const RechercheMessagePlaceholder(this.title, {this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return EmptyStatePlaceholder(
      illustration: Illustration.grey(AppIcons.search_rounded, withWhiteBackground: true),
      title: title,
      subtitle: subtitle,
    );
  }
}
