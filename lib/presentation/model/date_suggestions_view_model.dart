import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class DateSuggestionListViewModel {
  final List<DateSuggestionViewModel> suggestions;

  factory DateSuggestionListViewModel.createFuture(DateTime now) {
    return DateSuggestionListViewModel(suggestions: [
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
      DateSuggestionViewModel(
        "${Strings.dateSuggestionSemainePro} (${now.toMondayOnNextWeek().toDayOfWeek()})",
        "${Strings.dateSuggestionSemainePro} (${now.toMondayOnNextWeek().toDayWithFullMonth()})",
        now.toMondayOnNextWeek(),
      ),
    ]);
  }

  factory DateSuggestionListViewModel.createPast(DateTime now, DateTime? firstDate) {
    final yesterday = now.add(Duration(days: -1));
    return DateSuggestionListViewModel(suggestions: [
      if (firstDate != null && now.isAfter(firstDate))
        DateSuggestionViewModel(
          "${Strings.dateSuggestionAujourdhui} (${now.toDayOfWeek()})",
          "${Strings.dateSuggestionAujourdhui} (${now.toDayWithFullMonth()})",
          now,
        ),
      if (firstDate != null && yesterday.isAfter(firstDate))
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
