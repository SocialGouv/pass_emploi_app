import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class ImmersionTags extends StatelessWidget {
  final String secteurActivite;
  final String ville;

  ImmersionTags({required this.secteurActivite, required this.ville}) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Tag(label: secteurActivite),
        Tag(label: ville, icon: SvgPicture.asset(Drawables.icPlace)),
      ],
    );
  }
}
