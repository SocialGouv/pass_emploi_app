import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/contact_page_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  group('ContactPageViewModel', () {
    group('when app is CEJ', () {
      test('should return expected email subject for login mode MILO', () {
        // Given
        final store = givenState().loggedInMiloUser().store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "Mission Locale - Prise de contact avec l’équipe de l’application du CEJ");
      });

      test('should return expected email subject for login mode POLE_EMPLOI', () {
        // Given
        final store = givenState().loggedInPoleEmploiUser().store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "France Travail - Prise de contact avec l’équipe de l’application du CEJ");
      });

      test('should return expected email subject for login mode PASS_EMPLOI', () {
        // Given
        final store = givenState().copyWith(loginState: successPassEmploiUserState()).store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "Pass Emploi - Prise de contact avec l’équipe de l’application du CEJ");
      });
    });

    group('when brand is BRSA', () {
      test('should return expected email subject for login mode MILO', () {
        // Given
        final store = givenBrsaState().loggedInMiloUser().store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "Mission Locale - Prise de contact avec l’équipe de l’application pass emploi");
      });

      test('should return expected email subject for login mode POLE_EMPLOI', () {
        // Given
        final store = givenBrsaState().loggedInPoleEmploiUser().store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "France Travail - Prise de contact avec l’équipe de l’application pass emploi");
      });

      test('should return expected email subject for login mode PASS_EMPLOI', () {
        // Given
        final store = givenBrsaState().copyWith(loginState: successPassEmploiUserState()).store();

        // When
        final viewModel = ContactPageViewModel.create(store);

        // Then
        expect(viewModel.emailSubject, "Pass Emploi - Prise de contact avec l’équipe de l’application pass emploi");
      });
    });
  });
}
