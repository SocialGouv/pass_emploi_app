import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/cv/cv_list_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class PostulerOffreBottomSheet extends StatelessWidget {
  final void Function() onPostuler;

  PostulerOffreBottomSheet({Key? key, required this.onPostuler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.postulerOffreTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(AppIcons.description_rounded, color: AppColors.primary),
              SizedBox(width: Margins.spacing_base),
              Expanded(child: Text(Strings.postulerTitle, style: TextStyles.textMBold))
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          Expanded(child: CvList()),
          PrimaryActionButton(
            label: Strings.postulerContinueButton,
            icon: AppIcons.open_in_new_rounded,
            onPressed: onPostuler,
          ),
        ],
      ),
    );
  }
}
