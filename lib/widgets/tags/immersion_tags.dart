import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';

class ImmersionTags extends StatelessWidget {
  final String secteurActivite;
  final String ville;

  ImmersionTags({required this.secteurActivite, required this.ville}) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Margins.spacing_base,
      runSpacing: Margins.spacing_base,
      children: [
        DataTag(label: secteurActivite),
        DataTag(
          label: ville,
          iconSemantics: IconWithSemantics(AppIcons.place_outlined, Strings.iconAlternativeLocation),
        ),
      ],
    );
  }
}
