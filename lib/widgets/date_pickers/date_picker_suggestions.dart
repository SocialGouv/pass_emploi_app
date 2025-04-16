import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/presentation/model/date_suggestions_view_model.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/date_pickers/date_picker.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_chip.dart';

class DatePickerSuggestions extends StatelessWidget {
  final String title;
  final DateInputSource dateSource;
  final bool isForPastSuggestions;
  final DateTime? firstDate;
  final void Function(DateInputSource) onDateChanged;

  const DatePickerSuggestions({
    super.key,
    required this.title,
    required this.onDateChanged,
    required this.dateSource,
    this.firstDate,
    this.isForPastSuggestions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title, style: TextStyles.textBaseBold)),
        const SizedBox(height: Margins.spacing_s),
        DatePicker(
          onDateSelected: (date) => onDateChanged(DateFromPicker(date)),
          onDateDeleted: () => onDateChanged(DateNotInitialized()),
          firstDate: firstDate,
          initialDateValue: switch (dateSource) {
            DateNotInitialized _ => null,
            final DateFromSuggestion dateSource => dateSource.date,
            final DateFromPicker dateSource => dateSource.date,
          },
          isActiveDate: true,
          lastDate: isForPastSuggestions ? DateTime.now() : null,
        ),
        const SizedBox(height: Margins.spacing_s),
        _DateSuggestions(
          firstDate: firstDate,
          dateSource: dateSource,
          onSelected: onDateChanged,
          isForPastSuggestions: isForPastSuggestions,
        ),
      ],
    );
  }
}

class _DateSuggestions extends StatelessWidget {
  const _DateSuggestions({
    required this.onSelected,
    required this.dateSource,
    required this.isForPastSuggestions,
    this.firstDate,
  });

  final void Function(DateInputSource) onSelected;
  final DateInputSource dateSource;
  final bool isForPastSuggestions;
  final DateTime? firstDate;

  @override
  Widget build(BuildContext context) {
    final dateSuggestionsViewModel = isForPastSuggestions
        ? DateSuggestionListViewModel.createPast(DateTime.now(), firstDate)
        : DateSuggestionListViewModel.createFuture(DateTime.now());
    return Wrap(
      spacing: Margins.spacing_s,
      runSpacing: Margins.spacing_s,
      children: switch (dateSource) {
        DateNotInitialized() => dateSuggestionsViewModel.suggestions
            .map(
              (suggestion) => PassEmploiChip<DateTime>(
                label: suggestion.label,
                a11yLabel: suggestion.a11yLabel,
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
