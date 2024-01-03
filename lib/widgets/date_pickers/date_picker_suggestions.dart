import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/model/date_suggestions_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';

class DatePickerSuggestions extends StatelessWidget {
  const DatePickerSuggestions({super.key, required this.onDateChanged, required this.dateSource});
  final void Function(DateInputSource) onDateChanged;
  final DateInputSource dateSource;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.datePickerTitle, style: TextStyles.textBaseBold),
        const SizedBox(height: Margins.spacing_s),
        Text(Strings.dateFormat, style: TextStyles.textXsRegular()),
        const SizedBox(height: Margins.spacing_s),
        DatePicker(
          onValueChange: (date) => onDateChanged(DateFromPicker(date)),
          initialDateValue: switch (dateSource) {
            DateNotInitialized _ => null,
            final DateFromSuggestion dateSource => dateSource.date,
            final DateFromPicker dateSource => dateSource.date,
          },
          isActiveDate: true,
        ),
        const SizedBox(height: Margins.spacing_m),
        _DateSuggestions(
          dateSource: dateSource,
          onSelected: onDateChanged,
        ),
      ],
    );
  }
}

class _DateSuggestions extends StatelessWidget {
  const _DateSuggestions({required this.onSelected, required this.dateSource});

  final void Function(DateInputSource) onSelected;
  final DateInputSource dateSource;

  @override
  Widget build(BuildContext context) {
    final dateSuggestionsViewModel = DateSuggestionListViewModel.create(DateTime.now());
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (dateSource) {
        DateNotInitialized() => dateSuggestionsViewModel.suggestions
            .map(
              (suggestion) => PassEmploiChip<DateTime>(
                label: suggestion.label,
                value: suggestion.date,
                isSelected: false,
                onTagSelected: (value) => onSelected(DateFromSuggestion(
                  value,
                  suggestion.label,
                )),
                onTagDeleted: () => onSelected(DateNotInitialized()),
              ),
            )
            .toList(),
        DateFromSuggestion() => [
            PassEmploiChip<DateTime>(
              label: (dateSource as DateFromSuggestion).label,
              value: DateTime.now().add(Duration(days: 7)),
              isSelected: true,
              onTagSelected: (_) {},
              onTagDeleted: () => onSelected(DateNotInitialized()),
            ),
          ],
        DateFromPicker() => [],
      },
    );
  }
}
