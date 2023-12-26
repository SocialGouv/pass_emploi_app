import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/date_suggestions_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';

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
  final void Function(CreateActionDateSource) onDateChanged;

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
            Text(Strings.allMandatoryFields, style: TextStyles.textSRegular()),
            const SizedBox(height: Margins.spacing_m),
            Text(Strings.userActionStatusRadioStep3, style: TextStyles.textBaseBold),
            const SizedBox(height: Margins.spacing_base),
            _ActionStatusRadios(isCompleted: viewModel.estTerminee, onStatusChanged: onStatusChanged),
            const SizedBox(height: Margins.spacing_m),
            Text(Strings.userActionDateStep3, style: TextStyles.textBaseBold),
            const SizedBox(height: Margins.spacing_s),
            Text(Strings.dateFormat, style: TextStyles.textXsRegular()),
            const SizedBox(height: Margins.spacing_s),
            DatePicker(
              onValueChange: (date) => onDateChanged(CreateActionDateFromUserInput(date)),
              initialDateValue: switch (viewModel.dateSource) {
                CreateActionDateNotInitialized _ => null,
                final CreateActionDateFromSuggestions dateSource => dateSource.date,
                final CreateActionDateFromUserInput dateSource => dateSource.date,
              },
              isActiveDate: true,
            ),
            const SizedBox(height: Margins.spacing_m),
            _DateSuggestions(
              dateSource: viewModel.dateSource,
              onSelected: onDateChanged,
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

class _DateSuggestions extends StatelessWidget {
  const _DateSuggestions({required this.onSelected, required this.dateSource});

  final void Function(CreateActionDateSource) onSelected;
  final CreateActionDateSource dateSource;

  @override
  Widget build(BuildContext context) {
    final dateSuggestionsViewModel = CreateUserActionStep3DateSuggestions.create(DateTime.now());
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (dateSource) {
        CreateActionDateNotInitialized() => dateSuggestionsViewModel.suggestions
            .map(
              (suggestion) => PassEmploiChip<DateTime>(
                label: suggestion.label,
                value: suggestion.date,
                isSelected: false,
                onTagSelected: (value) => onSelected(CreateActionDateFromSuggestions(
                  value,
                  suggestion.label,
                )),
                onTagDeleted: () => onSelected(CreateActionDateNotInitialized()),
              ),
            )
            .toList(),
        CreateActionDateFromSuggestions() => [
            PassEmploiChip<DateTime>(
              label: (dateSource as CreateActionDateFromSuggestions).label,
              value: DateTime.now().add(Duration(days: 7)),
              isSelected: true,
              onTagSelected: (_) {},
              onTagDeleted: () => onSelected(CreateActionDateNotInitialized()),
            ),
          ],
        CreateActionDateFromUserInput() => [],
      },
    );
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
    return InkWell(
      onTap: () => onPressed(value),
      child: Row(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: (value) => onPressed(value),
            ),
          ),
          Text(title, style: TextStyles.textBaseRegular),
        ],
      ),
    );
  }
}
