import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/email_subject_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EmailObjectViewModel', () {
    group('contactEmailObject', () {
      group('when app is CEJ', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenState().loggedInMiloUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(
              viewModel.contactEmailObject, "Mission Locale - Prise de contact avec l’équipe de l’application du CEJ");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenState().loggedInPoleEmploiUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(
              viewModel.contactEmailObject, "France Travail - Prise de contact avec l’équipe de l’application du CEJ");
        });
      });

      group('when brand is BRSA', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenBrsaState().loggedInMiloUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.contactEmailObject,
              "Mission Locale - Prise de contact avec l’équipe de l’application pass emploi");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenBrsaState().loggedInPoleEmploiUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.contactEmailObject,
              "France Travail - Prise de contact avec l’équipe de l’application pass emploi");
        });
      });
    });

    group('ratingEmailObject', () {
      group('when app is CEJ', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenState().loggedInMiloUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "Mission Locale - Mon avis sur l’application du CEJ");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenState().loggedInPoleEmploiUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "France Travail - Mon avis sur l’application du CEJ");
        });
      });

      group('when brand is BRSA', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenBrsaState().loggedInMiloUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "Mission Locale - Mon avis sur l’application pass emploi");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenBrsaState().loggedInPoleEmploiUser().store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "France Travail - Mon avis sur l’application pass emploi");
        });
      });
    });
  });
}
