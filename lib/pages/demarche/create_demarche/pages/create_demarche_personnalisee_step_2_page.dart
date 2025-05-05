import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class CreateDemarchePersonnaliseeStep2Page extends StatefulWidget {
  const CreateDemarchePersonnaliseeStep2Page(this.viewModel);
  final CreateDemarcheFormViewModel viewModel;

  @override
  State<CreateDemarchePersonnaliseeStep2Page> createState() => _CreateDemarchePersonnaliseeStep2PageState();
}

class _CreateDemarchePersonnaliseeStep2PageState extends State<CreateDemarchePersonnaliseeStep2Page> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.viewModel.personnaliseeStep2ViewModel.description);
  }

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
          Text(Strings.descriptionDemarchePersonnaliseeLabel, style: TextStyles.textBaseMedium),
          const SizedBox(height: Margins.spacing_s),
          BaseTextField(
            controller: _controller,
            maxLength: CreateDemarchePersonnaliseeStep2ViewModel.maxLength,
            minLines: 4,
            onChanged: (value) => widget.viewModel.descriptionChanged(value),
          ),
          const SizedBox(height: Margins.spacing_base),
          PrimaryActionButton(
            label: Strings.continueLabel,
            onPressed: widget.viewModel.isDescriptionValid
                ? widget.viewModel.navigateToCreateDemarchePersonnaliseeStep3
                : null,
          ),
          SizedBox(height: Margins.spacing_xl),
        ],
      ),
    );
  }
}
