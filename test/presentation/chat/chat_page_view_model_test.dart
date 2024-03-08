import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_state.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
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
          Message("uid1", '1', DateTime(2021, 1, 1, 12, 30), Sender.jeune, MessageType.message, MessageStatus.sent, []),
          Message("uid2", '2', DateTime(2021, 1, 1, 15, 30), Sender.conseiller, MessageType.message, MessageStatus.sent,
              []),
          Message("uid3", '3', DateTime(2021, 1, 2, 16, 00), Sender.jeune, MessageType.message, MessageStatus.sent, []),
          Message("uid4", '4', DateTime(2021, 1, 2, 18, 30), Sender.conseiller, MessageType.message, MessageStatus.sent,
              []),
          Message("uid5", '5', todayAtNoon, Sender.jeune, MessageType.message, MessageStatus.sent, []),
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
      TextMessageItem(messageId: "uid1", content: '1', caption: '12:30 · Lu', sender: Sender.jeune),
      TextMessageItem(messageId: "uid2", content: '2', caption: '15:30', sender: Sender.conseiller),
      DayItem('Le 02/01/2021'),
      TextMessageItem(messageId: "uid3", content: '3', caption: '16:00 · Lu', sender: Sender.jeune),
      TextMessageItem(messageId: "uid4", content: '4', caption: '18:30', sender: Sender.conseiller),
      DayItem('Aujourd\'hui'),
      TextMessageItem(messageId: "uid5", content: '5', caption: '12:00 · Envoyé', sender: Sender.jeune),
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
          Message(
            "uid",
            'Une PJ',
            todayAtNoon,
            Sender.conseiller,
            MessageType.messagePj,
            MessageStatus.sent,
            [PieceJointe("id-1", "super.pdf")],
          ),
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
      PieceJointeConseillerMessageItem(
        messageId: "uid",
        pieceJointeId: "id-1",
        message: "Une PJ",
        filename: "super.pdf",
        caption: "12:00",
      ),
    ]);
  });

  group('Offre partagée', () {
    test('should display offre partagée from jeune', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super offre',
          todayAtNoon,
          Sender.jeune,
          MessageType.offre,
          MessageStatus.sent,
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
          messageId: "uid",
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
          "uid",
          'Super offre',
          todayAtNoon,
          Sender.conseiller,
          MessageType.offre,
          MessageStatus.sent,
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
          messageId: "uid",
          content: "Super offre",
          idPartage: "343",
          titrePartage: "Chevalier",
          type: OffreType.emploi,
          sender: Sender.conseiller,
          caption: "12:00",
        ),
      ]);
    });
  });

  group('Session milo partagé', () {
    test('should display event partagé from jeune', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super session milo',
          todayAtNoon,
          Sender.jeune,
          MessageType.sessionMilo,
          MessageStatus.sent,
          [],
          null,
          null,
          null,
          ChatSessionMilo("id-1", "Salon de l'emploi"),
        ),
      ];

      final store = givenState().chatSuccess(messages).store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [
        DayItem('Aujourd\'hui'),
        SessionMiloMessageItem(
          messageId: "uid",
          content: "Super session milo",
          idPartage: "id-1",
          titrePartage: "Salon de l'emploi",
          sender: Sender.jeune,
          caption: "12:00 · Envoyé",
        ),
      ]);
    });

    test('should display event partagé from conseiller', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super session milo',
          todayAtNoon,
          Sender.conseiller,
          MessageType.sessionMilo,
          MessageStatus.sent,
          [],
          null,
          null,
          null,
          ChatSessionMilo("id-1", "Salon de l'emploi"),
        ),
      ];

      final store = givenState().chatSuccess(messages).store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [
        DayItem('Aujourd\'hui'),
        SessionMiloMessageItem(
          messageId: "uid",
          content: "Super session milo",
          idPartage: "id-1",
          titrePartage: "Salon de l'emploi",
          sender: Sender.conseiller,
          caption: "12:00",
        ),
      ]);
    });
  });

  group('Event partagé', () {
    test('should display event partagé from jeune', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super event',
          todayAtNoon,
          Sender.jeune,
          MessageType.event,
          MessageStatus.sent,
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
          messageId: "uid",
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
          "uid",
          'Super event',
          todayAtNoon,
          Sender.conseiller,
          MessageType.event,
          MessageStatus.sent,
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
          messageId: "uid",
          content: "Super event",
          idPartage: "id-1",
          titrePartage: "atelier catapulte",
          sender: Sender.conseiller,
          caption: "12:00",
        ),
      ]);
    });
  });

  group('Evenement emploi partagé', () {
    test('should display evenement emploi partagé from jeune', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super evenement emploi',
          todayAtNoon,
          Sender.jeune,
          MessageType.evenementEmploi,
          MessageStatus.sent,
          [],
          null,
          null,
          ChatEvenementEmploi("oinzinfz98dqz", "Salon de l'emploi", "https://www.salondelemploi.fr"),
        ),
      ];
      final store = givenState().chatSuccess(messages).store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [
        DayItem('Aujourd\'hui'),
        EvenementEmploiMessageItem(
          messageId: "uid",
          content: "Super evenement emploi",
          idPartage: "oinzinfz98dqz",
          titrePartage: "Salon de l'emploi",
          sender: Sender.jeune,
          caption: "12:00 · Envoyé",
        ),
      ]);
    });

    test('should display evenement emploi partagé from conseiller', () {
      // Given
      final messages = [
        Message(
          "uid",
          'Super evenement emploi',
          todayAtNoon,
          Sender.conseiller,
          MessageType.evenementEmploi,
          MessageStatus.sent,
          [],
          null,
          null,
          ChatEvenementEmploi("oinzinfz98dqz", "Salon de l'emploi", "https://www.salondelemploi.fr"),
        ),
      ];
      final store = givenState().chatSuccess(messages).store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [
        DayItem('Aujourd\'hui'),
        EvenementEmploiMessageItem(
          messageId: "uid",
          content: "Super evenement emploi",
          idPartage: "oinzinfz98dqz",
          titrePartage: "Salon de l'emploi",
          sender: Sender.conseiller,
          caption: "12:00",
        ),
      ]);
    });
  });

  test('create when chat state is SUCCESS and message type is NOUVEAU_CONSEILLER', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [
          Message(
            "uid",
            'Jean-Paul',
            DateTime(2021, 1, 1, 12, 30),
            Sender.conseiller,
            MessageType.nouveauConseiller,
            MessageStatus.sent,
            [],
          )
        ],
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
        [
          Message("uid", 'Jean', DateTime(2021, 1, 1, 12, 30), Sender.conseiller,
              MessageType.nouveauConseillerTemporaire, MessageStatus.sent, [])
        ],
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
        [
          Message("uid", 'Jean-Paul', DateTime(2021, 1, 1, 12, 30), Sender.conseiller, MessageType.inconnu,
              MessageStatus.sent, [])
        ],
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
        Message("uid", 'PJ', DateTime(2021, 1, 1, 12, 30), Sender.jeune, MessageType.messagePj, MessageStatus.sent,
            [PieceJointe("1", "a.pdf")]),
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

  group('MessageStatus', () {
    test('when status is sending should display sending captions', () {
      // Given
      final message = _messageWithStatus(MessageStatus.sending);
      final state = AppState.initialState().copyWith(chatState: ChatSuccessState([message]));
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      final messageItem = viewModel.items[1] as TextMessageItem;
      expect(messageItem.shouldAnimate, true);
      expect(messageItem.caption.contains("Envoi en cours"), true);
      expect(messageItem.captionColor, null);
    });

    test('when status is sent should display sent captions', () {
      // Given
      final message = _messageWithStatus(MessageStatus.sent);
      final state = AppState.initialState().copyWith(chatState: ChatSuccessState([message]));
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      final messageItem = viewModel.items[1] as TextMessageItem;
      expect(messageItem.shouldAnimate, false);
      expect(messageItem.caption.contains("Envoyé"), true);
      expect(messageItem.captionColor, null);
    });

    test('when status is failed should display failed captions', () {
      // Given
      final message = _messageWithStatus(MessageStatus.failed);
      final state = AppState.initialState().copyWith(chatState: ChatSuccessState([message]));
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      final messageItem = viewModel.items[1] as TextMessageItem;
      expect(messageItem.shouldAnimate, false);
      expect(messageItem.caption.contains("L'envoi a échoué"), true);
      expect(messageItem.captionColor, AppColors.warning);
    });

    group('onboarding', () {
      test('should display onboarding', () {
        // Given
        final store = givenState()
            .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showChatOnboarding: true)))
            .store();

        // When
        final viewModel = ChatPageViewModel.create(store);

        // Then
        expect(viewModel.shouldShowOnboarding, isTrue);
      });

      test('should not display onboarding', () {
        // Given
        final store = givenState()
            .copyWith(onboardingState: OnboardingSuccessState(Onboarding(showChatOnboarding: false)))
            .store();

        // When
        final viewModel = ChatPageViewModel.create(store);

        // Then
        expect(viewModel.shouldShowOnboarding, isFalse);
      });
    });
  });
}

Message _messageWithStatus(MessageStatus status) =>
    Message("uid", '1', DateTime(2023, 10, 31), Sender.jeune, MessageType.message, status, []);
