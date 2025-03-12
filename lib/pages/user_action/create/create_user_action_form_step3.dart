import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/user_action/create/widgets/user_action_stepper.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_radio_buttons.dart';

class CreateUserActionFormStep3 extends StatelessWidget {
  const CreateUserActionFormStep3({
    required this.viewModel,
    required this.onStatusChanged,
    required this.withRappelChanged,
    required this.onDateChanged,
  });

  final CreateUserActionStep3ViewModel viewModel;
  final void Function(bool) onStatusChanged;
  final void Function(bool) withRappelChanged;
  final void Function(DateInputSource) onDateChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Tracker(
        tracking: AnalyticsScreenNames.createUserActionStep3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Margins.spacing_s),
              Semantics(
                container: true,
                header: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserActionStepperTexts(index: 3),
                    const SizedBox(height: Margins.spacing_s),
                    Text(Strings.userActionTitleStep3,
                        style: TextStyles.textMBold.copyWith(color: AppColors.contentColor)),
                  ],
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              MandatoryFieldsLabel.all(),
              const SizedBox(height: Margins.spacing_m),
              const SizedBox(height: Margins.spacing_base),
              Semantics(
                container: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Strings.userActionStatusRadioStep3, style: TextStyles.textBaseBold),
                    _ActionStatusRadios(isCompleted: viewModel.estTerminee, onStatusChanged: onStatusChanged),
                  ],
                ),
              ),
              const SizedBox(height: Margins.spacing_m),
              DatePickerSuggestions(
                title: Strings.datePickerTitle,
                dateSource: viewModel.dateSource,
                onDateChanged: (date) {
                  onDateChanged(date);
                  if (!date.isNone) {
                    // a11y : wait ui to be updated before moving focus
                    Future.delayed(Duration(milliseconds: 50), () {
                      if (context.mounted) FocusScope.of(context).nextFocus();
                    });
                  }
                },
              ),
              const SizedBox(height: Margins.spacing_m),
              if (viewModel.shouldDisplayRappelNotification())
                _RappelsSwitcher(
                  value: viewModel.withRappel,
                  onChanged: (value) => withRappelChanged(value),
                ),
              const SizedBox(height: Margins.spacing_xx_huge),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionStatusRadios extends StatelessWidget {
  const _ActionStatusRadios({required this.isCompleted, required this.onStatusChanged});

  final bool isCompleted;
  final void Function(bool) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: Column(
        children: [
          PassEmploiRadio<bool>(
            title: Strings.userActionStatusRadioCompletedStep3,
            value: true,
            groupValue: isCompleted,
            onPressed: _onStatusChanged,
          ),
          PassEmploiRadio<bool>(
            title: Strings.userActionStatusRadioTodoStep3,
            value: false,
            groupValue: isCompleted,
            onPressed: _onStatusChanged,
          ),
        ],
      ),
    );
  }

  void _onStatusChanged(bool? value) {
    if (value != null) onStatusChanged(value);
  }
}

class _RappelsSwitcher extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RappelsSwitcher({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyles.textBaseRegular;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Semantics(
            excludeSemantics: true,
            child: Text(Strings.rappelSwitch, style: textStyle),
          ),
        ),
        SizedBox(width: Margins.spacing_m),
        Semantics(
          label: Strings.rappelSwitch,
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(value ? Strings.yes : Strings.no, style: textStyle),
      ],
    );
  }
}
