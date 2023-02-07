import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ChatInformation extends StatelessWidget {
  final String title;
  final String description;

  const ChatInformation(this.title, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Margins.spacing_s),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Title(title: title),
            SizedBox(height: Margins.spacing_s),
            _Description(description: description),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;

  const _Title({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_xs),
          child: Icon(AppIcons.info_rounded, color: AppColors.primary),
        ),
        SizedBox(width: Margins.spacing_s),
        Flexible(
          child: Text(
            title,
            style: TextStyles.textBaseBoldWithColor(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  final String description;

  const _Description({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: TextStyles.textBaseRegularWithColor(AppColors.primary),
    );
  }
}
