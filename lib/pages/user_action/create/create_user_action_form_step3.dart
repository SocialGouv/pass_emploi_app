import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/mandatory_fields_label.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker_suggestions.dart';

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
    return Tracker(
      tracking: AnalyticsScreenNames.createUserActionStep3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Margins.spacing_m),
            MandatoryFieldsLabel.all(),
            const SizedBox(height: Margins.spacing_m),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.userActionStatusRadioStep3, style: TextStyles.textBaseBold),
                const SizedBox(height: Margins.spacing_base),
                _ActionStatusRadios(isCompleted: viewModel.estTerminee, onStatusChanged: onStatusChanged),
              ],
            ),
            const SizedBox(height: Margins.spacing_m),
            DatePickerSuggestions(
              title: Strings.datePickerTitle,
              dateSource: viewModel.dateSource,
              onDateChanged: onDateChanged,
            ),
            const SizedBox(height: Margins.spacing_m),
            if (viewModel.shouldDisplayRappelNotification())
              _RappelsSwitcher(
                value: viewModel.withRappel,
                onChanged: (value) => withRappelChanged(value),
              )
          ],
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
    return Column(
      children: [
        _PassEmploiRadio<bool>(
          title: Strings.userActionStatusRadioCompletedStep3,
          value: true,
          groupValue: isCompleted,
          onPressed: _onStatusChanged,
        ),
        _PassEmploiRadio<bool>(
          title: Strings.userActionStatusRadioTodoStep3,
          value: false,
          groupValue: isCompleted,
          onPressed: _onStatusChanged,
        ),
      ],
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
        Expanded(child: Text(Strings.rappelSwitch, style: textStyle)),
        SizedBox(width: Margins.spacing_m),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(value ? Strings.yes : Strings.no, style: textStyle),
      ],
    );
  }
}

class _PassEmploiRadio<T> extends StatelessWidget {
  const _PassEmploiRadio({
    super.key,
    required this.onPressed,
    required this.value,
    required this.groupValue,
    required this.title,
  });
  final void Function(T?) onPressed;
  final T value;
  final T groupValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "${value == groupValue ? Strings.selectedRadioButton : Strings.unselectedRadioButton} : $title",
      child: InkWell(
        onTap: () => onPressed(value),
        child: Semantics(
          excludeSemantics: true,
          child: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                // a11y : ingonre pointer to not take priority on semantic focus
                child: IgnorePointer(
                  child: Radio<T>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: (value) => onPressed(value),
                  ),
                ),
              ),
              Semantics(child: Text(title, style: TextStyles.textBaseRegular)),
            ],
          ),
        ),
      ),
    );
  }
}
