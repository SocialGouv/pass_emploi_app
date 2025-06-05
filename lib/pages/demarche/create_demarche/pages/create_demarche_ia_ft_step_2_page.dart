import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/information_bandeau.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateDemarcheIaFtStep2Page extends StatelessWidget {
  const CreateDemarcheIaFtStep2Page(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_base),
          Text(Strings.iaFtStep2Title, style: TextStyles.textMBold),
          const SizedBox(height: Margins.spacing_base),
          InformationBandeau(
            text: Strings.iaFtStep2Warning,
            icon: AppIcons.info_rounded,
            backgroundColor: AppColors.primaryLighten,
            textColor: AppColors.primary,
            borderRadius: Dimens.radius_base,
            padding: EdgeInsets.symmetric(
              vertical: Margins.spacing_s,
              horizontal: Margins.spacing_base,
            ),
          ),
          const SizedBox(height: Margins.spacing_base),
          Text(Strings.iaFtStep2FieldTitle, style: TextStyles.textBaseBold),
          const SizedBox(height: Margins.spacing_s),
          BaseTextField(
            hintText: Strings.iaFtStep2FieldHint,
            minLines: 6,
          ),
          const SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.iaFtStep2ButtonDicter,
            onPressed: () {},
            backgroundColor: AppColors.primaryLighten,
            textColor: AppColors.primary,
            iconColor: AppColors.primary,
            icon: Icons.mic,
            rippleColor: AppColors.primary.withOpacity(0.3),
          ),
          const SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.iaFtStep2Button,
            onPressed: () {},
          ),
          const SizedBox(height: Margins.spacing_base),
          SizedBox(height: Margins.spacing_xl),
        ],
      ),
    );
  }
}
