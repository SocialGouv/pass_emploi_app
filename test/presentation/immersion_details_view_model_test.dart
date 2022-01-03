import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:redux/redux.dart';

import '../doubles/spies.dart';

main() {
  test('create when state is loading should set display state properly', () {
    // Given
    final store = _store(State<ImmersionDetails>.loading());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when state is failure should set display state properly', () {
    // Given
    final store = _store(State<ImmersionDetails>.failure());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('create when state is success should set display state properly and fill generic immersion info', () {
    // Given
    final store = _store(State<ImmersionDetails>.success(_mockImmersion()));

    // When
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.title, 'Métier');
    expect(viewModel.companyName, 'Nom établissement');
    expect(viewModel.secteurActivite, 'Secteur');
    expect(viewModel.ville, 'Ville');
    expect(viewModel.address, 'Adresse');
  });

  group('Explanation label…', () {
    test('when enterprise is not volontaire', () {
      // Given
      final store = _successStore(_mockImmersion(isVolontaire: false));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

      // Then
      expect(
        viewModel.explanationLabel,
        'Cette entreprise peut recruter sur ce métier et être intéressée pour vous recevoir en immersion. Contactez-la en expliquant votre projet professionnel et vos motivations.',
      );
    });

    group('when enterprise is volontaire…', () {
      test('… and contact mode is unknown', () {
        // Given
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.INCONNU));

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
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.PHONE));

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
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.MAIL));

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
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.PRESENTIEL));

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
      test('does not have main CTA, only secondary address CTA (on Android)', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(null, address: "Address 1"));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withMainCallToAction, isFalse);
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(
          viewModel.secondaryCallToActions,
          [CallToAction('Localiser l\'entreprise', Uri.parse("geo:0,0?q=Address%201"))],
        );
      });

      test('does not have main CTA, only secondary address CTA (on iOS)', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(null, address: "Address 1"));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.IOS);

        // Then
        expect(viewModel.withMainCallToAction, isFalse);
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(
          viewModel.secondaryCallToActions,
          [CallToAction('Localiser l\'entreprise', Uri.parse("https://maps.apple.com/maps?q=Address+1"))],
        );
      });
    });

    group('when contact mode is INCONNU…', () {
      test('but neither phone neither mail is set > does not have main CTA, only secondary address CTA', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: ''),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withMainCallToAction, isFalse);
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(
          viewModel.secondaryCallToActions,
          [CallToAction('Localiser l\'entreprise', Uri.parse("geo:0,0?q=Address%201"))],
        );
      });

      test('but phone is unset > does not have main CTA, only secondary mail & address CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.INCONNU, phone: '', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withMainCallToAction, isFalse);
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(viewModel.secondaryCallToActions, [
          CallToAction(
            'Envoyer un e-mail',
            Uri.parse("mailto:mail?subject=Prise%20de%20contact%20au%20sujet%20de%20votre%20offre%20d'immersion"),
            drawableRes: Drawables.icMail,
          ),
          CallToAction('Localiser l\'entreprise', Uri.parse("geo:0,0?q=Address%201")),
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
        expect(viewModel.withMainCallToAction, isTrue);
        expect(viewModel.mainCallToAction, CallToAction('Appeler', Uri.parse("tel:0701020304")));
        expect(viewModel.withSecondaryCallToActions, isTrue);
        expect(viewModel.secondaryCallToActions.length, 2);
      });
    });

    group('when contact mode is MAIL', () {
      test('does have a main mail CTA, but secondary CTAs', () {
        // Given
        final store = _successStore(_mockImmersionWithContact(
          _mockContact(mode: ImmersionContactMode.MAIL, phone: 'phone', mail: 'mail'),
          address: "Address 1",
        ));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

        // Then
        expect(viewModel.withMainCallToAction, isTrue);
        expect(viewModel.withSecondaryCallToActions, isFalse);
        expect(
          viewModel.mainCallToAction,
          CallToAction(
            'Envoyer un e-mail',
            Uri.parse("mailto:mail?subject=Prise%20de%20contact%20au%20sujet%20de%20votre%20offre%20d'immersion"),
          ),
        );
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
        expect(viewModel.withMainCallToAction, isTrue);
        expect(viewModel.withSecondaryCallToActions, isFalse);
        expect(viewModel.mainCallToAction, CallToAction('Appeler', Uri.parse("tel:0701020304")));
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
        expect(viewModel.withMainCallToAction, isTrue);
        expect(viewModel.withSecondaryCallToActions, isFalse);
        expect(viewModel.mainCallToAction, CallToAction('Localiser l\'entreprise', Uri.parse("geo:0,0?q=Address%201")));
      });
    });
  });

  test('View model triggers ImmersionDetailsAction.request() when onRetry is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionDetailsViewModel.create(store, Platform.ANDROID);

    viewModel.onRetry("immersion-id");

    expect((store.dispatchedAction as ImmersionDetailsAction).isRequest(), isTrue);
    expect((store.dispatchedAction as ImmersionDetailsAction).getRequestOrThrow(), "immersion-id");
  });
}

Store<AppState> _store(State<ImmersionDetails> immersionDetailsState) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(immersionDetailsState: immersionDetailsState),
  );
}

Store<AppState> _successStore(ImmersionDetails immersion) => _store(State<ImmersionDetails>.success(immersion));

ImmersionDetails _mockImmersion({
  bool isVolontaire = false,
  ImmersionContactMode mode = ImmersionContactMode.INCONNU,
}) {
  return ImmersionDetails(
    id: '',
    metier: 'Métier',
    companyName: 'Nom établissement',
    secteurActivite: 'Secteur',
    ville: 'Ville',
    address: 'Adresse',
    isVolontaire: isVolontaire,
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
    isVolontaire: true,
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
