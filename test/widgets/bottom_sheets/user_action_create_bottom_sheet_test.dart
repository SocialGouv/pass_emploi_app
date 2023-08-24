import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/user_action_create_bottom_sheet.dart';

void main() {
  late bool formSubmitted;
  late ActionFormState state;

  setUp(() {
    formSubmitted = false;
    state = ActionFormState(onSubmit: (_) => formSubmitted = true);
  });

  group('ActionFormState', () {
    test("initial state should be empty", () {
      // Then
      expect(state.intitule, "");
      expect(state.description, "");
      expect(state.withRappel, false);
      expect(state.dateEcheance, null);
      expect(state.status, UserActionStatus.NOT_STARTED);
      expect(state.showIntituleError, false);
      expect(state.showDateEcheanceError, false);
    });

    test("when intitule changed, state should be updated", () {
      // Given
      const intitule = "intitule";

      // When
      state.intituleChanged(intitule);

      // Then
      expect(state.intitule, intitule);
      expect(state.showIntituleError, false);
    });

    test("when comment changed, state should be updated", () {
      // Given
      const description = "comment";

      // When
      state.descriptionChanged(description);

      // Then
      expect(state.description, description);
    });

    test("when rappel changed, state should be updated", () {
      // Given
      const withRappel = true;

      // When
      state.rappelChanged(withRappel);

      // Then
      expect(state.withRappel, withRappel);
    });

    test("when date changed, state should be updated", () {
      // Given
      final date = DateTime.now();

      // When
      state.dateEcheanceChanged(date);

      // Then
      expect(state.dateEcheance, date);
      expect(state.showDateEcheanceError, false);
    });

    test("when status changed, state should be updated", () {
      // Given
      const status = UserActionStatus.IN_PROGRESS;

      // When
      state.statusChanged(status);

      // Then
      expect(state.status, status);
    });

    // when content is empty and form is submitted, state should display errors

    test("when content is empty and form is submitted, state should display errors", () {
      // When
      state.submitForm();

      // Then
      expect(state.showIntituleError, true);
      expect(state.showDateEcheanceError, true);
    });

    test("when date is empty and intitulé is not empty should display date error", () {
      // Given
      state.intituleChanged("content");

      // When
      state.submitForm();

      // Then
      expect(state.showIntituleError, false);
      expect(state.showDateEcheanceError, true);
    });

    test("when intitule is empty and date is not empty should display date error", () {
      // Given
      state.dateEcheanceChanged(DateTime.now());

      // When
      state.submitForm();

      // Then
      expect(state.showIntituleError, true);
      expect(state.showDateEcheanceError, false);
    });

    test("when form is submitted and valid should call onFormSubmitted", () {
      // Given
      state.intituleChanged("content");
      state.dateEcheanceChanged(DateTime.now());

      // When
      state.submitForm();

      // Then
      expect(state.showIntituleError, false);
      expect(state.showDateEcheanceError, false);
      expect(formSubmitted, true);
    });

    test("when form is submitted and invalid should not call onFormSubmitted and display errors", () {
      // Given
      state.intituleChanged("content");

      // When
      state.submitForm();

      // Then
      expect(state.showIntituleError, false);
      expect(state.showDateEcheanceError, true);
      expect(formSubmitted, false);
    });

    test("when intitule was in error and change, state should not display errors", () {
      // Given
      state.submitForm();
      expect(state.showIntituleError, true);
      expect(state.showDateEcheanceError, true);

      // When
      state.intituleChanged("content");

      // Then
      expect(state.showIntituleError, false);
      expect(state.showDateEcheanceError, true);
    });

    test("when date was in error and change, state should not display errors", () {
      // Given
      state.submitForm();
      expect(state.showIntituleError, true);
      expect(state.showDateEcheanceError, true);

      // When
      state.dateEcheanceChanged(DateTime.now());

      // Then
      expect(state.showIntituleError, true);
      expect(state.showDateEcheanceError, false);
    });
  });
}
