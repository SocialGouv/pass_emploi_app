import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/model/date_suggestions_view_model.dart';

void main() {
  group('DateSuggestionListViewModel', () {
    test('should create suggestions with today, tomorrow and next monday', () {
      // Given
      final now = DateTime(2021, 1, 1);
      final suggestions = DateSuggestionListViewModel.createFuture(now);

      // When & Then
      expect(suggestions.suggestions.length, 3);
      expect(suggestions.suggestions[0].label, "Aujourd’hui (vendredi 1)");
      expect(suggestions.suggestions[0].date, DateTime(2021, 1, 1));
      expect(suggestions.suggestions[1].label, "Demain (samedi 2)");
      expect(suggestions.suggestions[1].date, DateTime(2021, 1, 2));
      expect(suggestions.suggestions[2].label, "Semaine prochaine (lundi 4)");
      expect(suggestions.suggestions[2].date, DateTime(2021, 1, 4));
    });
  });
}
