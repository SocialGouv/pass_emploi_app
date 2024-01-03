import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class DateSuggestionListViewModel {
  final List<DateSuggestionViewModel> suggestions;

  factory DateSuggestionListViewModel.create(DateTime now) {
    return DateSuggestionListViewModel(suggestions: [
      DateSuggestionViewModel("${Strings.userActionDateSuggestion1} (${now.toDayOfWeek()})", now),
      DateSuggestionViewModel("${Strings.userActionDateSuggestion2} (${now.add(Duration(days: 1)).toDayOfWeek()})",
          now.add(Duration(days: 1))),
      DateSuggestionViewModel(
          "${Strings.userActionDateSuggestion3} (${now.toMondayOnNextWeek().toDayOfWeek()})", now.toMondayOnNextWeek()),
    ]);
  }

  DateSuggestionListViewModel({required this.suggestions});
}

class DateSuggestionViewModel {
  final String label;
  final DateTime date;

  DateSuggestionViewModel(this.label, this.date);
}
