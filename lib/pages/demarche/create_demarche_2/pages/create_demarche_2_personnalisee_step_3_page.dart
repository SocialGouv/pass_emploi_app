import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';

class CreateDemarche2PersonnaliseeStep3Page extends StatelessWidget {
  const CreateDemarche2PersonnaliseeStep3Page(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Margins.spacing_base),
          Text(Strings.createDemarchePersonnaliseeTitle, style: TextStyles.textMBold),
          const SizedBox(height: Margins.spacing_base),
          Text(Strings.thematiquesDemarcheDateShortMandatory, style: TextStyles.textBaseMedium),
          const SizedBox(height: Margins.spacing_s),
          DatePickerSuggestions(
            title: Strings.datePickerTitle,
            dateSource: viewModel.personnaliseeStep3ViewModel.dateSource,
            onDateChanged: (date) {
              viewModel.dateDemarchePersonnaliseeChanged(date);
              if (!date.isNone) {
                // a11y : wait ui to be updated before moving focus
                Future.delayed(Duration(milliseconds: 50), () {
                  if (context.mounted) FocusScope.of(context).nextFocus();
                });
              }
            },
          ),
          const SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.addALaDemarche,
            onPressed: viewModel.isDemarchePersonnaliseeDateValid ? viewModel.submitDemarchePersonnalisee : null,
          ),
          SizedBox(height: Margins.spacing_xl),
        ],
      ),
    );
  }
}
