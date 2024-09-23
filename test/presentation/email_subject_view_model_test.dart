import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/presentation/email_subject_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EmailObjectViewModel', () {
    group('contactEmailObject', () {
      group('when accompagnement is and app are CEJ', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenState() //
              .loggedInUser(loginMode: LoginMode.MILO, accompagnement: Accompagnement.cej)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(
              viewModel.contactEmailObject, "Mission Locale - Prise de contact avec l’équipe de l’application du CEJ");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenState() //
              .loggedInUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(
              viewModel.contactEmailObject, "France Travail - Prise de contact avec l’équipe de l’application du CEJ");
        });
      });

      group('when accompagnement is RSA and app is pass emploi', () {
        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenPassEmploiState() //
              .loggedInUser(accompagnement: Accompagnement.rsaFranceTravail)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.contactEmailObject,
              "France Travail - RSA - Prise de contact avec l’équipe de l’application pass emploi");
        });
      });

      group('when accompagnement is AIJ and app is pass emploi', () {
        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenPassEmploiState() //
              .loggedInUser(accompagnement: Accompagnement.aij)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.contactEmailObject,
              "France Travail - AIJ - Prise de contact avec l’équipe de l’application pass emploi");
        });
      });
    });

    group('ratingEmailObject', () {
      group('when accompagnement is and app are CEJ', () {
        test('should return expected email subject for login mode MILO', () {
          // Given
          final store = givenState() //
              .loggedInUser(loginMode: LoginMode.MILO, accompagnement: Accompagnement.cej)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "Mission Locale - Mon avis sur l’application du CEJ");
        });

        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenState() //
              .loggedInUser(loginMode: LoginMode.POLE_EMPLOI, accompagnement: Accompagnement.cej)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "France Travail - Mon avis sur l’application du CEJ");
        });
      });

      group('when accompagnement is RSA and app is pass emploi', () {
        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenPassEmploiState() //
              .loggedInUser(accompagnement: Accompagnement.rsaFranceTravail)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "France Travail - RSA - Mon avis sur l’application pass emploi");
        });
      });

      group('when accompagnement is AIJ and app is pass emploi', () {
        test('should return expected email subject for login mode POLE_EMPLOI', () {
          // Given
          final store = givenPassEmploiState() //
              .loggedInUser(accompagnement: Accompagnement.aij)
              .store();

          // When
          final viewModel = EmailObjectViewModel.create(store);

          // Then
          expect(viewModel.ratingEmailObject, "France Travail - AIJ - Mon avis sur l’application pass emploi");
        });
      });
    });
  });
}
