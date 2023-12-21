import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
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
            const SizedBox(height: Margins.spacing_m),
            _ActionStatusRadios(isCompleted: viewModel.estTerminee, onStatusChanged: onStatusChanged),
            const SizedBox(height: Margins.spacing_m),
            Text(Strings.userActionDateStep3, style: TextStyles.textBaseBold),
            const SizedBox(height: Margins.spacing_m),
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
            _RappelsSwitcher(
              value: viewModel.withRappel,
              isActive: viewModel.shouldDisplayRappelNotification(),
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
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          title: Text(Strings.userActionStatusRadioCompletedStep3),
          value: true,
          groupValue: isCompleted,
          onChanged: _onStatusChanged,
        ),
        RadioListTile<bool>(
          contentPadding: EdgeInsets.zero,
          title: Text(Strings.userActionStatusRadioTodoStep3),
          value: false,
          groupValue: isCompleted,
          onChanged: _onStatusChanged,
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
    final today = DateTime.now();
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final nextWeek = DateTime.now().toMondayOnNextWeek();
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (dateSource) {
        CreateActionDateNotInitialized() => [
            PassEmploiChip<DateTime>(
              label: "${Strings.userActionDateSuggestion1} (${today.toDayOfWeek()})",
              value: today,
              isSelected: false,
              onTagSelected: (value) => onSelected(CreateActionDateFromSuggestions(
                value,
                Strings.userActionDateSuggestion1,
              )),
              onTagDeleted: () => onSelected(CreateActionDateNotInitialized()),
            ),
            PassEmploiChip<DateTime>(
              label: "${Strings.userActionDateSuggestion2} (${tomorrow.toDayOfWeek()})",
              value: tomorrow,
              isSelected: false,
              onTagSelected: (value) => onSelected(CreateActionDateFromSuggestions(
                value,
                Strings.userActionDateSuggestion2,
              )),
              onTagDeleted: () => onSelected(CreateActionDateNotInitialized()),
            ),
            PassEmploiChip<DateTime>(
              label: "${Strings.userActionDateSuggestion3} (${nextWeek.toDayOfWeek()})",
              value: nextWeek,
              isSelected: false,
              onTagSelected: (value) => onSelected(CreateActionDateFromSuggestions(
                value,
                Strings.userActionDateSuggestion3,
              )),
              onTagDeleted: () => onSelected(CreateActionDateNotInitialized()),
            ),
          ],
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
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _RappelsSwitcher({required this.value, required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textStyle = isActive ? TextStyles.textBaseRegular : TextStyles.textBaseRegularWithColor(AppColors.disabled);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(Strings.rappelSwitch, style: textStyle)),
        SizedBox(width: Margins.spacing_m),
        Switch(
          value: isActive && value,
          onChanged: isActive ? onChanged : null,
        ),
        SizedBox(width: Margins.spacing_xs),
        Text(isActive && value ? Strings.yes : Strings.no, style: textStyle),
      ],
    );
  }
}
