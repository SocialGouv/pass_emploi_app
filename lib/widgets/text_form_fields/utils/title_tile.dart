import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class TitleTile extends StatelessWidget {
  final String title;

  const TitleTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Margins.spacing_l),
        title: Text(title, style: TextStyles.textBaseBold),
      ),
    );
  }
}
