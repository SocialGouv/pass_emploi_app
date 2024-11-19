import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/tags/data_tag.dart';

class ImmersionTags extends StatelessWidget {
  final String secteurActivite;
  final String ville;

  ImmersionTags({required this.secteurActivite, required this.ville}) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: [
        DataTag(label: secteurActivite),
        DataTag.location(ville),
      ],
    );
  }
}
