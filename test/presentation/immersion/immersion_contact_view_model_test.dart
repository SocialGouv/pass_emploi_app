import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_contact_view_model.dart';
import 'package:pass_emploi_app/utils/platform.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('ImmersionContactViewModel', () {
    group('create', () {
      test('when state is not success should throws an error', () {
        expect(
          () => ImmersionContactViewModel.create(store: givenState().store(), platform: Platform.ANDROID),
          throwsException,
        );
      });

      test("when state is success should return a view model with a call to action 'phone'", () {
        // Given
        final store = givenState().withImmersionDetailsSuccess().store();

        // When
        final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

        // Then
        expect(viewModel.callToAction, isNotNull);
      });
    });

    group('Call to actions…', () {
      group('when contact is null…', () {
        test('have address CTA (on Android)', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(immersionDetails: _mockImmersionWithContact(null, address: "Address 1"))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("geo:0,0?q=Address%201"),
              EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
            ),
          );
        });

        test('have address CTA (on iOS)', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(immersionDetails: _mockImmersionWithContact(null, address: "Address 1"))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.IOS);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("https://maps.apple.com/maps?q=Address+1"),
              EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
            ),
          );
        });
      });

      group('when contact mode is INCONNU…', () {
        test('but neither phone nor mail is set > have address CTA', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(
                  immersionDetails: _mockImmersionWithContact(
                _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: ''),
                address: "Address 1",
              ))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("geo:0,0?q=Address%201"),
              EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
            ),
          );
        });

        test('but phone is unset > have address CTA', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(
                  immersionDetails: _mockImmersionWithContact(
                _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: 'mail'),
                address: "Address 1",
              ))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("geo:0,0?q=Address%201"),
              EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
            ),
          );
        });

        test('but phone is set > have  phone CTA,', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(
                  immersionDetails: _mockImmersionWithContact(
                _mockContact(mode: ImmersionContactMode.INCONNU, phone: '0701020304', mail: 'mail'),
                address: "Address 1",
              ))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Appeler',
              Uri.parse("tel:0701020304"),
              EvenementEngagement.OFFRE_IMMERSION_APPEL,
            ),
          );
        });
      });

      test('when contact mode is MAIL, should throws an exeption', () {
        final store = givenState()
            .withImmersionDetailsSuccess(
                immersionDetails: _mockImmersionWithContact(
              _mockContact(mode: ImmersionContactMode.MAIL, phone: 'phone', mail: 'mail'),
              address: "Address 1",
            ))
            .store();

        // When - Then
        expect(
          () => ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID),
          throwsException,
        );
      });

      group('when contact mode is PHONE', () {
        test('have phone CTA', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(
                  immersionDetails: _mockImmersionWithContact(
                _mockContact(mode: ImmersionContactMode.PHONE, phone: '0701020304', mail: 'mail'),
                address: "Address 1",
              ))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Appeler',
              Uri.parse("tel:0701020304"),
              EvenementEngagement.OFFRE_IMMERSION_APPEL,
            ),
          );
        });
      });

      group('when contact mode is IN PERSON', () {
        test('have adress CTA', () {
          // Given
          final store = givenState()
              .withImmersionDetailsSuccess(
                  immersionDetails: _mockImmersionWithContact(
                _mockContact(mode: ImmersionContactMode.PRESENTIEL, phone: '0701020304', mail: 'mail'),
                address: "Address 1",
              ))
              .store();

          // When
          final viewModel = ImmersionContactViewModel.create(store: store, platform: Platform.ANDROID);

          // Then
          expect(
            viewModel.callToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("geo:0,0?q=Address%201"),
              EvenementEngagement.OFFRE_IMMERSION_LOCALISATION,
            ),
          );
        });
      });
    });
  });
}

ImmersionDetails _mockImmersionWithContact(ImmersionContact? contact, {String? address}) {
  return ImmersionDetails(
    id: '',
    metier: '',
    companyName: '',
    secteurActivite: '',
    ville: '',
    address: address ?? '',
    codeRome: '',
    siret: '',
    fromEntrepriseAccueillante: true,
    contact: contact,
  );
}

ImmersionContact _mockContact({
  String? firstName,
  String? lastName,
  String? role,
  String? mail,
  String? phone,
  ImmersionContactMode? mode,
}) {
  return ImmersionContact(
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    phone: phone ?? '',
    mail: mail ?? '',
    role: role ?? '',
    mode: mode ?? ImmersionContactMode.INCONNU,
  );
}
