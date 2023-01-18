import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

import '../doubles/spies.dart';

void main() {
  test('create when state is loading should set display state properly', () {
    // Given
    final store = _store(ImmersionDetailsLoadingState());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, ImmersionDetailsPageDisplayState.SHOW_LOADER);
  });

  test('create when state is failure should set display state properly', () {
    // Given
    final store = _store(ImmersionDetailsFailureState());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, ImmersionDetailsPageDisplayState.SHOW_ERROR);
  });

  test('create when state is success should set display state properly and fill generic immersion info', () {
    // Given
    final store = _store(ImmersionDetailsSuccessState(_mockImmersion()));

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, ImmersionDetailsPageDisplayState.SHOW_DETAILS);
    expect(viewModel.id, '12345');
    expect(viewModel.title, 'Métier');
    expect(viewModel.companyName, 'Nom établissement');
    expect(viewModel.secteurActivite, 'Secteur');
    expect(viewModel.ville, 'Ville');
    expect(viewModel.address, 'Adresse');
  });

  test("getDetails when state is incomplete data should set display state properly and convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionDetailsState: ImmersionDetailsIncompleteDataState(Immersion(
          id: "10298",
          metier: "incomplete-metier",
          ville: "incomplete-ville",
          secteurActivite: "incomplete-secteur",
          nomEtablissement: "incomplete-nom",
        )),
      ),
    );

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS);
    expect(viewModel.id, "10298");
    expect(viewModel.title, "incomplete-metier");
    expect(viewModel.companyName, "incomplete-nom");
    expect(viewModel.secteurActivite, "incomplete-secteur");
    expect(viewModel.ville, "incomplete-ville");
    expect(viewModel.address, isNull);
    expect(viewModel.explanationLabel, isNull);
    expect(viewModel.contactLabel, isNull);
    expect(viewModel.contactInformation, isNull);
    expect(viewModel.withSecondaryCallToActions, isNull);
    expect(viewModel.mainCallToAction, isNull);
    expect(viewModel.secondaryCallToActions, isNull);
  });

  group('Explanation label…', () {
    test('when enterprise is not accueillante', () {
      // Given
      final store = _successStore(_mockImmersion(fromEntrepriseAccueillante: false));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(
        viewModel.explanationLabel,
        'Cette entreprise peut recruter sur ce métier et être intéressée pour vous recevoir en immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.',
      );
    });

    group('when enterprise is accueillante…', () {
      test('… and contact mode is unknown', () {
        // Given
        final store =
            _successStore(_mockImmersion(fromEntrepriseAccueillante: true, mode: ImmersionContactMode.INCONNU));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.explanationLabel,
          'Cette entreprise recherche activement des candidats à l’immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.',
        );
      });

      test('… and contact mode is phone', () {
        // Given
        final store = _successStore(_mockImmersion(fromEntrepriseAccueillante: true, mode: ImmersionContactMode.PHONE));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.explanationLabel,
          'Cette entreprise recherche activement des candidats à l’immersion. Contactez-la par téléphone en expliquant votre projet professionnel et vos motivations.',
        );
      });

      test('… and contact mode is mail', () {
        // Given
        final store = _successStore(_mockImmersion(fromEntrepriseAccueillante: true, mode: ImmersionContactMode.MAIL));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.explanationLabel,
          'Cette entreprise recherche activement des candidats à l’immersion. Contactez-la par e-mail en expliquant votre projet professionnel et vos motivations.\n\nVous n’avez pas besoin d’envoyer un CV.',
        );
      });

      test('… and contact mode is in person', () {
        // Given
        final store =
            _successStore(_mockImmersion(fromEntrepriseAccueillante: true, mode: ImmersionContactMode.PRESENTIEL));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.explanationLabel,
          'Cette entreprise recherche activement des candidats à l’immersion. Rendez-vous directement sur place pour expliquer votre projet professionnel et vos motivations.',
        );
      });
    });
  });

  group('Contact label…', () {
    test('when contact is not set', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(firstName: '', lastName: '', role: '')));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactLabel, '');
    });

    test('when contact is set with first name and last name', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(firstName: 'F', lastName: 'L', role: '')));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactLabel, 'F L');
    });

    test('when contact is set with first name, last name and role', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(firstName: 'F', lastName: 'L', role: 'R')));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactLabel, 'F L\nR');
    });
  });

  group('Contact information…', () {
    test('when contact is not set', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(null, address: "Address"));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactInformation, 'Address');
    });

    test('when contact mode is INCONNU should display all info', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(
        _mockContact(mail: 'Mail', phone: 'Phone', mode: ImmersionContactMode.INCONNU),
        address: "Address",
      ));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactInformation, 'Address\n\nMail\n\nPhone');
    });

    test('when contact mode is MAIL should only display address + mail', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(
        _mockContact(mail: 'Mail', phone: 'Phone', mode: ImmersionContactMode.MAIL),
        address: "Address",
      ));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactInformation, 'Address\n\nMail');
    });

    test('when contact mode is PHONE should only display address + phone', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(
        _mockContact(mail: 'Mail', phone: 'Phone', mode: ImmersionContactMode.PHONE),
        address: "Address",
      ));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactInformation, 'Address\n\nPhone');
    });

    test('when contact mode is PRESENTIEL should only display address', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(
        _mockContact(mail: 'Mail', phone: 'Phone', mode: ImmersionContactMode.PRESENTIEL),
        address: "Address",
      ));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(viewModel.contactInformation, 'Address');
    });
  });

  group('Call to actions…', () {
    group('when contact is null…', () {
      test('only have main address CTA (on Android), no secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(null, address: "Address 1"));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Localiser l\'entreprise',
            Uri.parse("geo:0,0?q=Address%201"),
            EventType.OFFRE_IMMERSION_LOCALISATION,
          ),
        );
        expect(viewModel.withSecondaryCallToActions, isFalse);
      });

      test('only have main address CTA (on iOS), no secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(null, address: "Address 1"));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.IOS);

        // Then
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Localiser l\'entreprise',
            Uri.parse("https://maps.apple.com/maps?q=Address+1"),
            EventType.OFFRE_IMMERSION_LOCALISATION,
          ),
        );
        expect(viewModel.withSecondaryCallToActions, isFalse);
      });
    });

    group('when contact mode is INCONNU…', () {
      test('but neither phone nor mail is set > only have main address CTA, no secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: ''),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Localiser l\'entreprise',
            Uri.parse("geo:0,0?q=Address%201"),
            EventType.OFFRE_IMMERSION_LOCALISATION,
          ),
        );
        expect(viewModel.withSecondaryCallToActions, isFalse);
      });

      test('but phone is unset > does have main address CTA and secondary mail CTA', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Localiser l\'entreprise',
            Uri.parse("geo:0,0?q=Address%201"),
            EventType.OFFRE_IMMERSION_LOCALISATION,
          ),
        );
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(viewModel.secondaryCallToActions, [
          CallToAction(
            'Envoyer un e-mail',
            Uri.parse("mailto:mail?subject=Candidature%20pour%20une%20p%C3%A9riode%20d'immersion"),
            EventType.OFFRE_IMMERSION_ENVOI_EMAIL,
            drawableRes: Drawables.icMail,
          )
        ]);
      });

      test('but phone is set > does have a main phone CTA, and secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.INCONNU, phone: '0701020304', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
            viewModel.mainCallToAction,
            CallToAction(
              'Appeler',
              Uri.parse("tel:0701020304"),
              EventType.OFFRE_IMMERSION_APPEL,
            ));
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(viewModel.secondaryCallToActions!.length, 2);
      });
    });

    group('when contact mode is MAIL', () {
      test('does have a main mail CTA, but no secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.MAIL, phone: 'phone', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Envoyer un e-mail',
            Uri.parse("mailto:mail?subject=Candidature%20pour%20une%20p%C3%A9riode%20d'immersion"),
            EventType.OFFRE_IMMERSION_ENVOI_EMAIL,
          ),
        );
        expect(viewModel.withSecondaryCallToActions, isFalse);
      });
    });

    group('when contact mode is PHONE', () {
      test('does have a main phone CTA, but secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.PHONE, phone: '0701020304', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withSecondaryCallToActions, isFalse);
        expect(
            viewModel.mainCallToAction,
            CallToAction(
              'Appeler',
              Uri.parse("tel:0701020304"),
              EventType.OFFRE_IMMERSION_APPEL,
            ));
      });
    });

    group('when contact mode is IN PERSON', () {
      test('does have a main location CTA, but secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.PRESENTIEL, phone: '0701020304', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withSecondaryCallToActions, isFalse);
        expect(
            viewModel.mainCallToAction,
            CallToAction(
              'Localiser l\'entreprise',
              Uri.parse("geo:0,0?q=Address%201"),
              EventType.OFFRE_IMMERSION_LOCALISATION,
            ));
      });
    });
  });

  test('View model triggers ImmersionDetailsAction.request() when onRetry is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    viewModel.onRetry("immersion-id");

    expect(store.dispatchedAction, isA<ImmersionDetailsRequestAction>());
    expect((store.dispatchedAction as ImmersionDetailsRequestAction).immersionId, "immersion-id");
  });
}

Store<AppState> _store(ImmersionDetailsState immersionDetailsState) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(immersionDetailsState: immersionDetailsState),
  );
}

Store<AppState> _successStore(ImmersionDetails immersion) => _store(ImmersionDetailsSuccessState(immersion));

ImmersionDetails _mockImmersion({
  bool fromEntrepriseAccueillante = false,
  ImmersionContactMode mode = ImmersionContactMode.INCONNU,
}) {
  return ImmersionDetails(
    id: '12345',
    metier: 'Métier',
    companyName: 'Nom établissement',
    secteurActivite: 'Secteur',
    ville: 'Ville',
    address: 'Adresse',
    fromEntrepriseAccueillante: fromEntrepriseAccueillante,
    contact: ImmersionContact(
      firstName: '',
      lastName: '',
      phone: '',
      mail: '',
      role: '',
      mode: mode,
    ),
  );
}

ImmersionDetails _mockImmersionWithContact(ImmersionContact? contact, {String? address}) {
  return ImmersionDetails(
    id: '',
    metier: '',
    companyName: '',
    secteurActivite: '',
    ville: '',
    address: address ?? '',
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
