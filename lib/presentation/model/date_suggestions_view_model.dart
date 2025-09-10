import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class DateSuggestionListViewModel {
  final List<DateSuggestionViewModel> suggestions;

  factory DateSuggestionListViewModel.createFuture(DateTime now) {
    return DateSuggestionListViewModel(suggestions: [
      DateSuggestionViewModel(
        "${Strings.dateSuggestionHier} (${now.subtract(Duration(days: 1)).toDayOfWeek()})",
        "${Strings.dateSuggestionHier} (${now.subtract(Duration(days: 1)).toDayWithFullMonth()})",
        now.subtract(Duration(days: 1)),
      ),
      DateSuggestionViewModel(
        "${Strings.dateSuggestionAujourdhui} (${now.toDayOfWeek()})",
        "${Strings.dateSuggestionAujourdhui} (${now.toDayWithFullMonth()})",
        now,
      ),
      DateSuggestionViewModel(
        "${Strings.dateSuggestionDemain} (${now.add(Duration(days: 1)).toDayOfWeek()})",
        "${Strings.dateSuggestionDemain} (${now.add(Duration(days: 1)).toDayWithFullMonth()})",
        now.add(Duration(days: 1)),
      ),
    ]);
  }

  factory DateSuggestionListViewModel.createPast(DateTime now, DateTime? firstDate) {
    final yesterday = now.add(Duration(days: -1));

    bool isValid(DateTime date) {
      return firstDate == null || !date.isBefore(firstDate);
    }

    return DateSuggestionListViewModel(suggestions: [
      if (isValid(now))
        DateSuggestionViewModel(
          "${Strings.dateSuggestionAujourdhui} (${now.toDayOfWeek()})",
          "${Strings.dateSuggestionAujourdhui} (${now.toDayWithFullMonth()})",
          now,
        ),
      if (isValid(yesterday))
        DateSuggestionViewModel(
          "${Strings.dateSuggestionHier} (${yesterday.toDayOfWeek()})",
          "${Strings.dateSuggestionHier} (${yesterday.toDayWithFullMonth()})",
          yesterday,
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
