import 'package:flutter_test/flutter_test.dart';

import '../doubles/fixtures.dart';

void main() {
  group('update user action', () {
    test('should update action date based on dateFin', () {
      // Given
      final action = mockUserAction(dateEcheance: DateTime(2024));

      // When
      final result = action.update(mockUserActionUpdateRequest(
        dateEcheance: DateTime(2024),
        dateFin: DateTime(2025),
      ));

      // Then
      expect(result.dateFin, DateTime(2025));
    });

    test('should not update action date based on dateFin when not provided', () {
      // Given
      final action = mockUserAction(dateEcheance: DateTime(2024));

      // When
      final result = action.update(mockUserActionUpdateRequest(
        dateEcheance: DateTime(2024),
      ));

      // Then
      expect(result.dateFin, DateTime(2024));
    });
  });
}
