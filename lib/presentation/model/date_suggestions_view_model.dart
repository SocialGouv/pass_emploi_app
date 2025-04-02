import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class DateSuggestionListViewModel {
  final List<DateSuggestionViewModel> suggestions;

  factory DateSuggestionListViewModel.create(DateTime now) {
    return DateSuggestionListViewModel(suggestions: [
      DateSuggestionViewModel(
        "${Strings.userActionDateSuggestion1} (${now.toDayOfWeek()})",
        "${Strings.userActionDateSuggestion1} (${now.toDayWithFullMonth()})",
        now,
      ),
      DateSuggestionViewModel(
        "${Strings.userActionDateSuggestion2} (${now.add(Duration(days: 1)).toDayOfWeek()})",
        "${Strings.userActionDateSuggestion2} (${now.add(Duration(days: 1)).toDayWithFullMonth()})",
        now.add(Duration(days: 1)),
      ),
      DateSuggestionViewModel(
        "${Strings.userActionDateSuggestion3} (${now.toMondayOnNextWeek().toDayOfWeek()})",
        "${Strings.userActionDateSuggestion3} (${now.toMondayOnNextWeek().toDayWithFullMonth()})",
        now.toMondayOnNextWeek(),
      ),
    ]);
  }

  DateSuggestionListViewModel({required this.suggestions});
}

class DateSuggestionViewModel {
  final String label;
  final String a11yLabel;
  final DateTime date;

  DateSuggestionViewModel(this.label, this.a11yLabel, this.date);
}
