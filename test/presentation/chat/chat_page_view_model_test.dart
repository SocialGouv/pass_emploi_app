import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  final now = DateTime.now();
  final todayAtNoon = DateTime(now.year, now.month, now.day, 12, 00);

  test('create when chat state is LOADING', () {
    // Given
    final state = AppState.initialState().copyWith(chatState: ChatLoadingState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when chat state is FAILURE', () {
    // Given
    final state = AppState.initialState().copyWith(chatState: ChatFailureState());
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('create when chat state is SUCCESS', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatStatusState: ChatStatusSuccessState(unreadMessageCount: 0, lastConseillerReading: DateTime(2021, 1, 2, 18)),
      chatState: ChatSuccessState(
        [
          Message('1', DateTime(2021, 1, 1, 12, 30), Sender.jeune, MessageType.message, []),
          Message('2', DateTime(2021, 1, 1, 15, 30), Sender.conseiller, MessageType.message, []),
          Message('3', DateTime(2021, 1, 2, 16, 00), Sender.jeune, MessageType.message, []),
          Message('4', DateTime(2021, 1, 2, 18, 30), Sender.conseiller, MessageType.message, []),
          Message('5', todayAtNoon, Sender.jeune, MessageType.message, []),
        ],
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Le 01/01/2021'),
      JeuneMessageItem(content: '1', caption: '12:30 · Lu'),
      ConseillerMessageItem(content: '2', caption: '15:30'),
      DayItem('Le 02/01/2021'),
      JeuneMessageItem(content: '3', caption: '16:00 · Lu'),
      ConseillerMessageItem(content: '4', caption: '18:30'),
      DayItem('Aujourd\'hui'),
      JeuneMessageItem(content: '5', caption: '12:00 · Envoyé'),
    ]);
  });

  test('should have a brouillon when saved', () {
    // Given
    final store = givenState().chatBrouillon("coucou").store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.brouillon, "coucou");
  });

  test('should not have a message brouillon when empty', () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.brouillon, null);
  });

  test('should display piece jointe from conseiller', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatStatusState: ChatStatusSuccessState(unreadMessageCount: 0, lastConseillerReading: DateTime(2021, 1, 2, 18)),
      chatState: ChatSuccessState(
        [
          Message('Une PJ', todayAtNoon, Sender.conseiller, MessageType.messagePj, [PieceJointe("id-1", "super.pdf")]),
        ],
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      PieceJointeConseillerMessageItem(id: "id-1", message: "Une PJ", filename: "super.pdf", caption: "12:00"),
    ]);
  });

  test('should display offre partagée from jeune', () {
    // Given
    final messages = [
      Message(
        'Super offre',
        todayAtNoon,
        Sender.jeune,
        MessageType.offre,
        [],
        Offre(
          "343",
          "Chevalier",
          OffreType.emploi,
        ),
      )
    ];
    final store = givenState().chatSuccess(messages).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      OffreMessageItem(
        content: "Super offre",
        idPartage: "343",
        titrePartage: "Chevalier",
        type: OffreType.emploi,
        sender: Sender.jeune,
        caption: "12:00 · Envoyé",
      ),
    ]);
  });

  test('should display offre partagée from conseiller', () {
    // Given
    final messages = [
      Message(
        'Super offre',
        todayAtNoon,
        Sender.conseiller,
        MessageType.offre,
        [],
        Offre("343", "Chevalier", OffreType.emploi),
      )
    ];
    final store = givenState().chatSuccess(messages).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      OffreMessageItem(
        content: "Super offre",
        idPartage: "343",
        titrePartage: "Chevalier",
        type: OffreType.emploi,
        sender: Sender.conseiller,
        caption: "12:00",
      ),
    ]);
  });

  test('should display event partagé from jeune', () {
    // Given
    final messages = [
      Message(
        'Super event',
        todayAtNoon,
        Sender.jeune,
        MessageType.event,
        [],
        null,
        Event(
          id: "id-1",
          type: RendezvousTypeCode.ATELIER,
          titre: "atelier catapulte",
        ),
      ),
    ];
    final store = givenState().chatSuccess(messages).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      EventMessageItem(
        content: "Super event",
        idPartage: "id-1",
        titrePartage: "atelier catapulte",
        sender: Sender.jeune,
        caption: "12:00 · Envoyé",
      ),
    ]);
  });

  test('should display event partagé from conseiller', () {
    // Given
    final messages = [
      Message(
        'Super event',
        todayAtNoon,
        Sender.conseiller,
        MessageType.event,
        [],
        null,
        Event(
          id: "id-1",
          type: RendezvousTypeCode.ATELIER,
          titre: "atelier catapulte",
        ),
      ),
    ];
    final store = givenState().chatSuccess(messages).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      EventMessageItem(
        content: "Super event",
        idPartage: "id-1",
        titrePartage: "atelier catapulte",
        sender: Sender.conseiller,
        caption: "12:00",
      ),
    ]);
  });

  test('create when chat state is SUCCESS and message type is NOUVEAU_CONSEILLER', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [Message('Jean-Paul', DateTime(2021, 1, 1, 12, 30), Sender.conseiller, MessageType.nouveauConseiller, [])],
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      InformationItem("Vous échangez avec votre nouveau conseiller", "Il a accès à l’historique de vos échanges"),
    ]);
  });

  test('create when chat state is SUCCESS and message type is NOUVEAU_CONSEILLER_TEMPORAIRE', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [Message('Jean', DateTime(2021, 1, 1, 12, 30), Sender.conseiller, MessageType.nouveauConseillerTemporaire, [])],
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      InformationItem(
          "Vous échangez temporairement avec un nouveau conseiller", "Il a accès à l’historique de vos échanges"),
    ]);
  });

  test('create when chat state is SUCCESS and message type is UNKNOWN', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [Message('Jean-Paul', DateTime(2021, 1, 1, 12, 30), Sender.conseiller, MessageType.inconnu, [])],
      ),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      InformationItem(
        "Le message est inaccessible",
        "Pour avoir l'accès au contenu veuillez mettre à jour l'application",
      ),
    ]);
  });

  test('create when chat state is SUCCESS and message type is PJ from jeune', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState([
        Message('PJ', DateTime(2021, 1, 1, 12, 30), Sender.jeune, MessageType.messagePj, [PieceJointe("1", "a.pdf")]),
      ]),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      InformationItem(
        "Le message est inaccessible",
        "Pour avoir l'accès au contenu veuillez mettre à jour l'application",
      ),
    ]);
  });
}
