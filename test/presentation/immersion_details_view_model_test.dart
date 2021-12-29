import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/spies.dart';

main() {
  test('create when state is loading should set display state properly', () {
    // Given
    final store = _store(State<ImmersionDetails>.loading());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when state is failure should set display state properly', () {
    // Given
    final store = _store(State<ImmersionDetails>.failure());

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('create when state is success should set display state properly and fill generic immersion info', () {
    // Given
    final store = _store(State<ImmersionDetails>.success(_mockImmersion()));

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

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
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(
        viewModel.explanationLabel,
        'Cette entreprise peut recruter sur ce métier et être intéressée pour vous vous recevoir en immersion.',
      );
    });

    group('when enterprise is volontaire…', () {
      test('… and contact mode is unknown', () {
        // Given
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.UNKNOWN));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store);

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
        final viewModel = ImmersionDetailsViewModel.create(store);

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
        final viewModel = ImmersionDetailsViewModel.create(store);

        // Then
        expect(
          viewModel.explanationLabel,
          'Cette entreprise recherche activement des candidats à l’immersion. Contactez-la par e-mail en expliquant votre projet professionnel et vos motivations. Vous n’avez pas besoin d’envoyer un CV.',
        );
      });

      test('… and contact mode is in person', () {
        // Given
        final store = _successStore(_mockImmersion(isVolontaire: true, mode: ImmersionContactMode.IN_PERSON));

        // When
        final viewModel = ImmersionDetailsViewModel.create(store);

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
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactLabel, '');
    });

    test('when contact is set with first name and last name', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(firstName: 'F', lastName: 'L', role: '')));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactLabel, 'F L');
    });

    test('when contact is set with first name, last name and role', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(firstName: 'F', lastName: 'L', role: 'R')));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactLabel, 'F L\nR');
    });
  });

  group('Contact information…', () {
    test('when contact is not set', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(null, address: "Address"));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactInformation, 'Address');
    });

    test('when contact is set without mail and phone', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(mail: '', phone: ''), address: "Address"));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactInformation, 'Address');
    });

    test('when contact is set with mail', () {
      // Given
      final store = _successStore(_mockImmersionWithContact(_mockContact(mail: 'Mail', phone: ''), address: "Address"));

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactInformation, 'Address\nMail');
    });

    test('when contact is set with phone', () {
      // Given
      final store = _successStore(
        _mockImmersionWithContact(_mockContact(mail: '', phone: 'Phone'), address: "Address"),
      );

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactInformation, 'Address\nPhone');
    });

    test('when contact is set with mail and phone', () {
      // Given
      final store = _successStore(
        _mockImmersionWithContact(_mockContact(mail: 'Mail', phone: 'Phone'), address: "Address"),
      );

      // When
      final viewModel = ImmersionDetailsViewModel.create(store);

      // Then
      expect(viewModel.contactInformation, 'Address\nMail\nPhone');
    });
  });

  test('View model triggers ImmersionDetailsAction.request() when onRetry is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionDetailsViewModel.create(store);

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
  ImmersionContactMode mode = ImmersionContactMode.UNKNOWN,
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
}) {
  return ImmersionContact(
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    phone: phone ?? '',
    mail: mail ?? '',
    role: role ?? '',
    mode: ImmersionContactMode.UNKNOWN,
  );
}
