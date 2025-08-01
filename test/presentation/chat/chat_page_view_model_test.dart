import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/message_important/message_important_state.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/message_important.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat/chat_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  final now = DateTime.now();
  final todayAtNoon = DateTime(now.year, now.month, now.day, 12, 00);

  test('create when chat state is LOADING', () {
    // Given
    final store = givenState().copyWith(chatState: ChatLoadingState()).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when chat state is FAILURE', () {
    // Given
    final store = givenState().copyWith(chatState: ChatFailureState()).store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('create when chat state is SUCCESS', () {
    // Given
    final messages = [
      Message(
        id: "id0",
        content: '1',
        creationDate: DateTime(2021, 1, 1, 11, 30),
        sentBy: Sender.jeune,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.deleted,
        pieceJointes: [],
      ),
      Message(
        id: "id1",
        content: '1',
        creationDate: DateTime(2021, 1, 1, 12, 30),
        sentBy: Sender.jeune,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
      Message(
        id: "id2",
        content: '2',
        creationDate: DateTime(2021, 1, 1, 15, 30),
        sentBy: Sender.conseiller,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.edited,
        pieceJointes: [],
      ),
      Message(
        id: "id3",
        content: '3',
        creationDate: DateTime(2021, 1, 2, 16, 00),
        sentBy: Sender.jeune,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.edited,
        pieceJointes: [],
      ),
      Message(
        id: "id4",
        content: '4',
        creationDate: DateTime(2021, 1, 2, 18, 30),
        sentBy: Sender.conseiller,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
      Message(
        id: "id5",
        content: '5',
        creationDate: todayAtNoon,
        sentBy: Sender.jeune,
        type: MessageType.message,
        sendingStatus: MessageSendingStatus.sent,
        contentStatus: MessageContentStatus.content,
        pieceJointes: [],
      ),
    ];

    final store = givenState()
        .chatSuccess(messages)
        .copyWith(
          chatStatusState: ChatStatusSuccessState(
            hasUnreadMessages: false,
            lastConseillerReading: DateTime(2021, 1, 2, 18),
          ),
        )
        .store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Le 01/01/2021'),
      DeletedMessageItem("id0", Sender.jeune, "Message supprimé"),
      TextMessageItem(messageId: "id1", content: '1', caption: '12:30 · Lu', sender: Sender.jeune),
      TextMessageItem(messageId: "id2", content: '2', caption: '15:30 · Modifié', sender: Sender.conseiller),
      DayItem('Le 02/01/2021'),
      TextMessageItem(messageId: "id3", content: '3', caption: '16:00 · Modifié', sender: Sender.jeune),
      TextMessageItem(messageId: "id4", content: '4', caption: '18:30', sender: Sender.conseiller),
      DayItem('Aujourd\'hui'),
      TextMessageItem(messageId: "id5", content: '5', caption: '12:00 · Envoyé', sender: Sender.jeune),
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
    final message = Message(
      id: "uid",
      content: 'Une PJ',
      creationDate: todayAtNoon,
      sentBy: Sender.conseiller,
      type: MessageType.messagePj,
      sendingStatus: MessageSendingStatus.sent,
      contentStatus: MessageContentStatus.content,
      pieceJointes: [PieceJointe("id-1", "super.pdf", PieceJointeAnalyseStatut.aFaire)],
    );

    final store = givenState()
        .chatSuccess([message])
        .copyWith(
          chatStatusState: ChatStatusSuccessState(
            hasUnreadMessages: false,
            lastConseillerReading: DateTime(2021, 1, 2, 18),
          ),
        )
        .store();

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem('Aujourd\'hui'),
      PieceJointeMessageItem(
        sender: Sender.conseiller,
        messageId: "uid",
        pieceJointeId: "id-1",
        message: "Une PJ",
        filename: "super.pdf",
        caption: "12:00",
      ),
    ]);
  });

  test('should display piece jointe from jeune', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState([
        Message(
          id: "uid",
          content: 'PJ',
          creationDate: DateTime(2021, 1, 1, 12, 30),
          sentBy: Sender.jeune,
          type: MessageType.messagePj,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.aFaire)],
        ),
      ]),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      PieceJointeMessageItem(
        sender: Sender.jeune,
        messageId: "uid",
        pieceJointeId: "1",
        message: null,
        filename: "a.pdf",
        caption: "12:30 · Envoi en cours",
        captionColor: null,
        shouldAnimate: false,
      ),
    ]);
  });

  test('should display image from jeune', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState([
        Message(
          id: "uid",
          content: 'PJ',
          creationDate: DateTime(2021, 1, 1, 12, 30),
          sentBy: Sender.jeune,
          type: MessageType.messagePj,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [PieceJointe("1", "a.png", PieceJointeAnalyseStatut.valide)],
        ),
      ]),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      PieceJointeImageItem(
        messageId: "uid",
        pieceJointeId: "1",
        pieceJointeName: "a.png",
        caption: "12:30 · Envoyé",
        captionColor: null,
        shouldAnimate: false,
      ),
    ]);
  });

  test('should display local image from jeune', () {
    // Given
    final state = givenState().copyWith(
      chatState: ChatSuccessState([
        Message(
          id: "uid",
          content: 'PJ',
          localPieceJointePath: "path",
          creationDate: DateTime(2021, 1, 1, 12, 30),
          sentBy: Sender.jeune,
          type: MessageType.localImagePj,
          sendingStatus: MessageSendingStatus.sending,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [PieceJointe("1", "a.png", PieceJointeAnalyseStatut.aFaire)],
        ),
      ]),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      LocalImageMessageItem(
        messageId: "uid",
        imagePath: "path",
        showLoading: true,
        caption: "12:30 · Envoi en cours",
        captionColor: null,
        shouldAnimate: true,
      ),
    ]);
  });

  test('should display local file from jeune', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState([
        Message(
          id: "uid",
          content: 'PJ',
          localPieceJointePath: "a.pdf",
          creationDate: DateTime(2021, 1, 1, 12, 30),
          sentBy: Sender.jeune,
          type: MessageType.localFilePj,
          sendingStatus: MessageSendingStatus.sending,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.aFaire)],
        ),
      ]),
    );
    final store = Store<AppState>(reducer, initialState: state);

    // When
    final viewModel = ChatPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [
      DayItem("Le 01/01/2021"),
      LocalFileMessageItem(
        messageId: "uid",
        showLoading: true,
        fileName: "a.pdf",
        caption: "12:30 · Envoi en cours",
        captionColor: null,
        shouldAnimate: true,
      ),
    ]);
  });

  group('Offre partagée', () {
    test('should display offre partagée from jeune', () {
      // Given
      final messages = [
        Message(
          id: "uid",
          content: 'Super offre',
          creationDate: todayAtNoon,
          sentBy: Sender.jeune,
          type: MessageType.offre,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          offre: MessageOffre(
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
          id: "uid",
          content: 'Super offre',
          creationDate: todayAtNoon,
          sentBy: Sender.conseiller,
          type: MessageType.offre,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          offre: MessageOffre("343", "Chevalier", OffreType.emploi),
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
          id: "uid",
          content: 'Super session milo',
          creationDate: todayAtNoon,
          sentBy: Sender.jeune,
          type: MessageType.sessionMilo,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          sessionMilo: ChatSessionMilo("id-1", "Salon de l'emploi"),
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
          id: "uid",
          content: 'Super session milo',
          creationDate: todayAtNoon,
          sentBy: Sender.conseiller,
          type: MessageType.sessionMilo,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          sessionMilo: ChatSessionMilo("id-1", "Salon de l'emploi"),
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
  group('Action partagé', () {
    test('should display action partagé', () {
      // Given
      final messages = [
        Message(
          id: "uid",
          content: 'Super action',
          creationDate: todayAtNoon,
          sentBy: Sender.conseiller,
          type: MessageType.messageAction,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          action: MessageAction("action_id", "Salon de l'emploi"),
        ),
      ];

      final store = givenState().chatSuccess(messages).store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [
        DayItem('Aujourd\'hui'),
        ActionMessageItem(
          messageId: "uid",
          content: "Super action",
          idPartage: "action_id",
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
          id: "uid",
          content: 'Super event',
          creationDate: todayAtNoon,
          sentBy: Sender.jeune,
          type: MessageType.event,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          event: Event(
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
          id: "uid",
          content: 'Super event',
          creationDate: todayAtNoon,
          sentBy: Sender.conseiller,
          type: MessageType.event,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          event: Event(
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
          id: "uid",
          content: 'Super evenement emploi',
          creationDate: todayAtNoon,
          sentBy: Sender.jeune,
          type: MessageType.evenementEmploi,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          evenementEmploi: ChatEvenementEmploi("oinzinfz98dqz", "Salon de l'emploi", "https://www.salondelemploi.fr"),
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
          id: "uid",
          content: 'Super evenement emploi',
          creationDate: todayAtNoon,
          sentBy: Sender.conseiller,
          type: MessageType.evenementEmploi,
          sendingStatus: MessageSendingStatus.sent,
          contentStatus: MessageContentStatus.content,
          pieceJointes: [],
          evenementEmploi: ChatEvenementEmploi("oinzinfz98dqz", "Salon de l'emploi", "https://www.salondelemploi.fr"),
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
            id: "uid",
            content: 'Jean-Paul',
            creationDate: DateTime(2021, 1, 1, 12, 30),
            sentBy: Sender.conseiller,
            type: MessageType.nouveauConseiller,
            sendingStatus: MessageSendingStatus.sent,
            contentStatus: MessageContentStatus.content,
            pieceJointes: [],
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
      InformationItem("Vous échangez avec votre nouveau conseiller.", "Il a accès à l’historique de vos échanges."),
    ]);
  });

  test('create when chat state is SUCCESS and message type is NOUVEAU_CONSEILLER_TEMPORAIRE', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [
          Message(
            id: "uid",
            content: 'Jean',
            creationDate: DateTime(2021, 1, 1, 12, 30),
            sentBy: Sender.conseiller,
            type: MessageType.nouveauConseillerTemporaire,
            sendingStatus: MessageSendingStatus.sent,
            contentStatus: MessageContentStatus.content,
            pieceJointes: [],
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
      InformationItem(
          "Vous échangez temporairement avec un nouveau conseiller.", "Il a accès à l’historique de vos échanges."),
    ]);
  });

  test('create when chat state is SUCCESS and message type is UNKNOWN', () {
    // Given
    final state = AppState.initialState().copyWith(
      chatState: ChatSuccessState(
        [
          Message(
            id: "uid",
            content: 'Jean-Paul',
            creationDate: DateTime(2021, 1, 1, 12, 30),
            sentBy: Sender.conseiller,
            type: MessageType.inconnu,
            sendingStatus: MessageSendingStatus.sent,
            contentStatus: MessageContentStatus.content,
            pieceJointes: [],
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
      InformationItem(
        "Le message est inaccessible",
        "Pour avoir l'accès au contenu, veuillez mettre à jour l'application.",
      ),
    ]);
  });

  group('MessageStatus', () {
    test('when status is sending should display sending captions', () {
      // Given
      final message = _messageWithStatus(MessageSendingStatus.sending);
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
      final message = _messageWithStatus(MessageSendingStatus.sent);
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
      final message = _messageWithStatus(MessageSendingStatus.failed);
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
  });

  group('piece jointe', () {
    test('should display pj picker when user is milo', () {
      // Given
      final store = givenState().loggedInMiloUser().store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.jeunePjEnabled, isTrue);
    });

    test('should display pj picker when user is from Avenir Pro', () {
      // Given
      final store = givenState()
          .loggedInUser(
            loginMode: LoginMode.POLE_EMPLOI,
            accompagnement: Accompagnement.avenirPro,
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.jeunePjEnabled, isTrue);
    });

    test('should not display pj picker when user is from FT', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.jeunePjEnabled, isFalse);
    });
  });

  group('messageImportant', () {
    test('should display nothing when date debut is in the future', () {
      // Given
      final state = givenState().copyWith(
        messageImportantState:
            MessageImportantSuccessState(message: dummyMessageImportant(dateDebut: now.add(Duration(days: 1)))),
      );
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.messageImportant, null);
    });

    test('should display nothing when date fin is in the past', () {
      // Given
      final state = givenState().copyWith(
        messageImportantState:
            MessageImportantSuccessState(message: dummyMessageImportant(dateFin: now.subtract(Duration(days: 1)))),
      );
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.messageImportant, null);
    });

    test('should display nothing when message is empty', () {
      // Given
      final state = givenState().copyWith(
        messageImportantState: MessageImportantSuccessState(
            message: MessageImportant(
          dateFin: now.add(Duration(days: 1)),
          dateDebut: now.subtract(Duration(days: 1)),
          message: "",
        )),
      );
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.messageImportant, null);
    });

    test('should display message', () {
      // Given
      final state = givenState().copyWith(
        messageImportantState: MessageImportantSuccessState(
            message: MessageImportant(
          dateFin: now.add(Duration(days: 1)),
          dateDebut: now.subtract(Duration(days: 1)),
          message: "Je veux revoir les montages Gandalf",
        )),
      );
      final store = Store<AppState>(reducer, initialState: state);

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(viewModel.messageImportant, "Je veux revoir les montages Gandalf");
    });
  });

  group('piece jointe analyse statut', () {
    test('when is aFaire, should display loading caption even if last conseiller reading is after', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.aFaire),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>().having(
          (e) => e.caption,
          "caption",
          "12:30 · Envoi en cours",
        ),
      );
    });

    test('when is enCours, should display loading caption even if last conseiller reading is after', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.enCours),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>().having(
          (e) => e.caption,
          "caption",
          "12:30 · Envoi en cours",
        ),
      );
    });

    test('when is valide and message is not read, should display success caption', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.valide),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2010),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>().having(
          (e) => e.caption,
          "caption",
          "12:30 · Envoyé",
        ),
      );
    });

    test('when is valide and message is read, should display success caption', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.valide),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>().having(
          (e) => e.caption,
          "caption",
          "12:30 · Lu",
        ),
      );
    });

    test('when is nonValide, should display erreur caption even if conseiller has read', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.nonValide),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>()
            .having(
              (e) => e.captionColor,
              "captionColor",
              AppColors.warning,
            )
            .having(
              (e) => e.caption,
              "caption",
              "12:30 · L'envoi a échoué",
            ),
      );
    });

    test('when is erreur, should display erreur caption', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.erreur),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<PieceJointeItem>()
            .having(
              (e) => e.captionColor,
              "captionColor",
              AppColors.warning,
            )
            .having(
              (e) => e.caption,
              "caption",
              "12:30 · L'envoi a échoué",
            ),
      );
    });

    test('when is expiree, should display deleted item', () {
      // Given
      final store = givenState()
          .chatSuccess([
            mockMessage(
              type: MessageType.messagePj,
              pieceJointe: PieceJointe("1", "a.pdf", PieceJointeAnalyseStatut.expiree),
            ),
          ])
          .copyWith(
            chatStatusState: ChatStatusSuccessState(
              hasUnreadMessages: false,
              lastConseillerReading: DateTime(2030),
            ),
          )
          .store();

      // When
      final viewModel = ChatPageViewModel.create(store);

      // Then
      expect(
        viewModel.items[1],
        isA<DeletedMessageItem>().having(
          (e) => e.content,
          "content",
          "Pièce jointe expirée",
        ),
      );
    });
  });
}

Message _messageWithStatus(MessageSendingStatus status) => Message(
      id: "uid",
      content: '1',
      creationDate: DateTime(2023, 10, 31),
      sentBy: Sender.jeune,
      type: MessageType.message,
      sendingStatus: status,
      contentStatus: MessageContentStatus.content,
      pieceJointes: [],
    );
