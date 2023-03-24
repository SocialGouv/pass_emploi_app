import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/immersion_contact_form_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ImmersionContactFormPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ImmersionContactFormPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ImmersionContactFormViewModel>(
      converter: (store) => ImmersionContactFormViewModel.create(store),
      builder: (context, viewModel) => _Content(viewModel),
      distinct: true,
    );
  }
}

class _Content extends StatelessWidget {
  final ImmersionContactFormViewModel viewModel;
  const _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(title: Strings.immersitionContactFormTitle),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: Strings.immersionContactFormButton,
              icon: AppIcons.outgoing_mail,
              onPressed: () {},
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Margins.spacing_base),
                Text(
                  Strings.immersitionContactFormSubtitle,
                  style: TextStyles.textBaseRegular,
                ),
                SizedBox(height: Margins.spacing_m),
                Text(
                  Strings.immersitionContactFormHint,
                  style: TextStyles.textBaseBold,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  initialValue: viewModel.userEmailInitialValue,
                  label: Strings.immersitionContactFormEmailHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  initialValue: viewModel.userFirstNameInitialValue,
                  label: Strings.immersitionContactFormSurnameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  initialValue: viewModel.userLastNameInitialValue,
                  label: Strings.immersitionContactFormNameHint,
                ),
                SizedBox(height: Margins.spacing_m),
                ImmersionTextFormField(
                  isMandatory: true,
                  maxLines: 10,
                  initialValue: viewModel.messageInitialValue,
                  label: Strings.immersitionContactFormMessageHint,
                ),
                SizedBox(height: Margins.spacing_huge * 2),
              ],
            ),
          ),
        ));
  }
}

class ImmersionTextFormField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final bool isMandatory;
  final String? mandatoryError;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  const ImmersionTextFormField({
    this.initialValue,
    required this.isMandatory,
    this.mandatoryError,
    this.onChanged,
    required this.label,
    this.maxLines = 1,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${isMandatory ? "*" : null}$label", style: TextStyles.textBaseMedium),
        SizedBox(height: Margins.spacing_base),
        TextFormField(
          initialValue: initialValue,
          minLines: 1,
          maxLines: maxLines,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              errorText: mandatoryError,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius_base),
                borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
              )),
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyles.textBaseMedium,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
