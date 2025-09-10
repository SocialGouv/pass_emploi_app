import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/model/date_suggestions_view_model.dart';

void main() {
  group('DateSuggestionListViewModel', () {
    test('should create suggestions with today, tomorrow and next monday', () {
      // Given
      final now = DateTime(2021, 1, 4);
      final suggestions = DateSuggestionListViewModel.createFuture(now);

      // When & Then
      expect(suggestions.suggestions.length, 3);
      expect(suggestions.suggestions[0].label, "Hier (dimanche 3)");
      expect(suggestions.suggestions[0].date, DateTime(2021, 1, 3));
      expect(suggestions.suggestions[1].label, "Aujourd’hui (lundi 4)");
      expect(suggestions.suggestions[1].date, DateTime(2021, 1, 4));
      expect(suggestions.suggestions[2].label, "Demain (mardi 5)");
      expect(suggestions.suggestions[2].date, DateTime(2021, 1, 5));
    });
  });
}
