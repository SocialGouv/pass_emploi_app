import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/test_setup.dart';

void main() {
  test("On chat first subscription, chat is loading then display messages", () async {
    // Given
    final factory = TestStoreFactory();
    final repository = ChatRepositoryStub();
    repository.onMessageStreamReturns([_mockMessage()]);
    factory.chatRepository = repository;
    final store = factory.initializeReduxStore(initialState: loggedInState());
    final displayedLoading = store.onChange.any((element) => element.chatState is ChatLoadingState);
    final newState = store.onChange.firstWhere((element) => element.chatState is ChatSuccessState);

    // When
    store.dispatch(SubscribeToChatAction());

    // Then
    expect(await displayedLoading, true);
    expect(((await newState).chatState as ChatSuccessState).messages, [_mockMessage()]);
  });

  test("On chat other subscriptions, previous chat messages are displayed first, then new ones are displayed",
      () async {
    // Given
    final factory = TestStoreFactory();
    final repository = ChatRepositoryStub();
    repository.onMessageStreamReturns([_mockMessage('1'), _mockMessage('2')]);
    factory.chatRepository = repository;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginSuccessState(mockUser()),
        chatState: ChatSuccessState([_mockMessage('1')]),
      ),
    );
    final newState1 = store.onChange.firstWhere((e) => e.chatState is ChatSuccessState);
    final newState2 = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length > 1);

    // When
    store.dispatch(SubscribeToChatAction());

    // Then
    expect(((await newState1).chatState as ChatSuccessState).messages, [_mockMessage('1')]);
    expect(((await newState2).chatState as ChatSuccessState).messages, [_mockMessage('1'), _mockMessage('2')]);
  });

  test("On chat subscription, if crypto is not initialized, then failure is displayed", () async {
    // Given
    final factory = TestStoreFactory();
    final repository = ChatRepository(NotInitializedDummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());
    factory.chatRepository = repository;
    final store = factory.initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginSuccessState(mockUser()),
      ),
    );
    final newState = store.onChange.firstWhere((e) => e.chatState is ChatFailureState);

    // When
    store.dispatch(SubscribeToChatAction());

    // Then
    expect((await newState).chatState, ChatFailureState());
  });

  group("Pagination du chat", () {
    late ChatRepositoryMock repository;
    late Store<AppState> store;

    setUp(() async {
      repository = ChatRepositoryMock();
      store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
      await store.dispatch(SubscribeToChatAction());
    });

    Future<AppState> waitingChange(bool Function(List<Message>) callback) async {
      return store.onChange.firstWhere((appState) {
        final chatState = appState.chatState as ChatSuccessState;
        return callback(chatState.messages);
      });
    }

    void whenMessagesSent(List<Message> messages) {
      repository.publishMessagesOnStream(messages);
    }

    Future<void> givenMessagesAlreadySent(List<Message> messages) async {
      final waitingState = waitingChange((messages) => messages.length == messages.length);
      whenMessagesSent(messages);
      await waitingState;
    }

    Future<void> givenPastMessagesAlreadyFetched(List<Message> messages) async {
      repository.oldMessagesRequested = messages;
      await store.dispatch(ChatRequestMorePastAction());
    }

    group("quand de nouveaux messages arrivent", () {
      test("on voit pour la première fois les messages", () async {
        // Given
        final messageSent = [_message(1), _message(2)];
        final newState = waitingChange((messages) => messages.length >= 2);

        // When
        whenMessagesSent(messageSent);

        // Then
        expect(((await newState).chatState as ChatSuccessState).messages, messageSent);
      });

      test("on voit les nouveaux messages reçus ainsi que ceux précédement reçus, ordre ASC, sans doublon", () async {
        // Given
        await givenMessagesAlreadySent([_message(1), _message(2)]);
        final newState = waitingChange((messages) => messages.length >= 3);

        // When
        whenMessagesSent([_message(2), _message(3)]);

        // Then
        expect(((await newState).chatState as ChatSuccessState).messages, [_message(1), _message(2), _message(3)]);
      });

      test("on voit les nouveaux messages reçus et la pagination dans le passé, ordre ASC, sans doublon", () async {
        // Given
        await givenMessagesAlreadySent([_message(11), _message(12)]);
        repository.oldMessagesRequested = [_message(4), _message(5), _message(6)];
        final newState = waitingChange((messages) => messages.length >= 5);

        // When
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(
          ((await newState).chatState as ChatSuccessState).messages,
          [_message(4), _message(5), _message(6), _message(11), _message(12)],
        );
      });

      test("on peut charger plusieurs fois le passé, ordre ASC, sans doublon", () async {
        // Given
        repository.numberOfHistoryMessage = 3;
        await givenMessagesAlreadySent([_message(11), _message(12)]);
        await givenPastMessagesAlreadyFetched([_message(4), _message(5), _message(6)]);
        repository.oldMessagesRequested = [_message(1), _message(2), _message(3)];
        final newState = waitingChange((messages) => messages.length >= 8);

        // When
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(
          ((await newState).chatState as ChatSuccessState).messages,
          [_message(1), _message(2), _message(3), _message(4), _message(5), _message(6), _message(11), _message(12)],
        );
      });

      test("on ne charge pas le passé quand on est arrivé au tout début de l'historique", () async {
        // Given
        repository.numberOfHistoryMessage = 3;
        await givenMessagesAlreadySent([_message(11), _message(12)]);
        await givenPastMessagesAlreadyFetched([_message(5), _message(6)]); // 2 reçus < 3 demandés
        repository.oldMessagesRequested = [_message(3), _message(4)];

        // When
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(repository.numberOfOldMessagesCalled, 1);
      });

      test("on voit uniquement les derniers nouveaux messages reçus lorsque l'historique est cassé", () async {
        // Given
        await givenMessagesAlreadySent([_message(1), _message(2)]);
        final newState = waitingChange((messages) => messages.contains(_message(8)));

        // When
        repository.publishMessagesOnStream([_message(8), _message(9)]);

        // Then
        expect(((await newState).chatState as ChatSuccessState).messages, [_message(8), _message(9)]);
      });
    });
  });

  test("should keep a brouillon message", () async {
    // Given
    final store = givenState().store();
    final appStateFuture = store.onChange.first;

    // When
    await store.dispatch(SaveChatBrouillonAction("hey"));

    // Then
    final appState = await appStateFuture;
    expect(appState.chatBrouillonState, ChatBrouillonState("hey"));
  });

  test("should reset brouillon when sending a message", () async {
    // Given
    final store = givenState().chatBrouillon("wip").store();
    final appStateFuture = store.onChange.first;

    // When
    await store.dispatch(SendMessageAction("done"));

    // Then
    final appState = await appStateFuture;
    expect(appState.chatBrouillonState, ChatBrouillonState(null));
  });

  group('Partage actions', () {
    final sut = StoreSut();
    late MockTrackingEventRepository trackingEventRepository;
    late _MockChatRepository mockChatRepository;

    setUp(() {
      trackingEventRepository = MockTrackingEventRepository();
      registerFallbackValue(EventType.ANIMATION_COLLECTIVE_PARTAGEE);
      when(
        () => trackingEventRepository.sendEvent(
          userId: 'id',
          event: any(named: "event"),
          loginMode: LoginMode.MILO,
          brand: Brand.cej,
        ),
      ).thenAnswer((_) async => true);

      mockChatRepository = _MockChatRepository();
      sut.givenStore = givenState() //
          .loggedInUser()
          .store(
            (f) => {
              f.chatRepository = mockChatRepository,
              f.trackingEventRepository = trackingEventRepository,
            },
          );
    });

    group('partage event action', () {
      sut.whenDispatchingAction(() => ChatPartagerEventAction(dummyEventPartage()));

      test('should dispatch loading then succeed when an event is successfully partagé', () async {
        // Given
        mockChatRepository.onSendEventPartageSuccess(dummyEventPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an event fails to be shared', () {
        // Given
        mockChatRepository.onSendEventPartageFailure(dummyEventPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when event is successfully partagé', () async {
        // Given
        mockChatRepository.onSendEventPartageSuccess(dummyEventPartage());

        // Then
        sut.then(
          () => verify(
            () => trackingEventRepository.sendEvent(
              userId: 'id',
              event: EventType.ANIMATION_COLLECTIVE_PARTAGEE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('partage offre emploi action', () {
      sut.whenDispatchingAction(() => ChatPartagerOffreAction(dummyOffrePartagee()));

      setUpAll(() {
        registerFallbackValue(EventType.EVENEMENT_EXTERNE_PARTAGE);
        registerFallbackValue(LoginMode.MILO);
      });

      test('should dispatch loading then succeed when an offre is successfully partagée', () async {
        // Given
        mockChatRepository.onPartageOffreEmploiSucceeds(dummyOffrePartagee());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an offre fails to be shared', () {
        // Given
        mockChatRepository.onPartageOffreEmploiFails(dummyOffrePartagee());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when offre is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageOffreEmploiSucceeds(dummyOffrePartagee());

        // Then
        sut.then(
          () => verify(
            () => trackingEventRepository.sendEvent(
              userId: 'id',
              event: EventType.MESSAGE_OFFRE_PARTAGEE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('partage evenement emploi', () {
      sut.whenDispatchingAction(() => ChatPartagerEvenementEmploiAction(dummyEvenementEmploiPartage()));

      test('should dispatch loading then succeed action an evenement emploi is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageEvenementEmploiSucceeds(dummyEvenementEmploiPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when an evenement emploi fails to be shared', () {
        // Given
        mockChatRepository.onPartageEvenementEmploiFails(dummyEvenementEmploiPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when event is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageEvenementEmploiSucceeds(dummyEvenementEmploiPartage());

        // Then
        sut.then(
          () => verify(
            () => trackingEventRepository.sendEvent(
              userId: 'id',
              event: EventType.EVENEMENT_EXTERNE_PARTAGE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('partage session milo', () {
      sut.whenDispatchingAction(() => ChatPartagerSessionMiloAction(dummySessionMiloPartage()));

      test('should dispatch loading then succeed action a session milo is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageSessionMiloSuccess(dummySessionMiloPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageSuccessState>((state) => state.chatPartageState),
        ]);
      });

      test('should dispatch loading then failure when a session milo fails to be shared', () {
        // Given
        mockChatRepository.onPartageSessionMiloFails(dummySessionMiloPartage());

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          StateIs<ChatPartageLoadingState>((state) => state.chatPartageState),
          StateIs<ChatPartageFailureState>((state) => state.chatPartageState),
        ]);
      });

      test('should track when session milo is successfully partagé', () async {
        // Given
        mockChatRepository.onPartageSessionMiloSuccess(dummySessionMiloPartage());

        // Then
        sut.then(
          () => verify(
            () => trackingEventRepository.sendEvent(
              userId: 'id',
              event: EventType.MESSAGE_SESSION_MILO_PARTAGE,
              loginMode: LoginMode.MILO,
              brand: Brand.cej,
            ),
          ).called(1),
        );
      });
    });

    group('sendMessage', () {
      final sut = StoreSut();
      late _MockChatRepository mockChatRepository;

      setUp(() {
        mockChatRepository = _MockChatRepository();
        sut.givenStore = givenState() //
            .loggedInUser()
            .store(
              (f) => {
                f.chatRepository = mockChatRepository,
              },
            );
      });

      sut.whenDispatchingAction(() => SendMessageAction("message"));

      setUpAll(() => registerFallbackValue(_mockMessage()));

      test('should display a message when sending is in progress', () async {
        // Given
        mockChatRepository.onSendMessageSuccess();

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          _stateIsChatSuccessStateOfMessageStatus(MessageStatus.sending),
        ]);
      });

      test('should display a message when sending failed', () async {
        // Given
        mockChatRepository.onSendMessageFailure();

        // When & Then
        sut.thenExpectChangingStatesThroughOrder([
          _stateIsChatSuccessStateOfMessageStatus(MessageStatus.sending),
          _stateIsChatSuccessStateOfMessageStatus(MessageStatus.failed),
        ]);
      });
    });
  });
}

StateIs<ChatSuccessState> _stateIsChatSuccessStateOfMessageStatus(MessageStatus status) {
  return StateIs<ChatSuccessState>((state) => state.chatState, (state) => expect(state.messages.last.status, status));
}

Message _mockMessage([String id = '1']) {
  return Message(
    "uid",
    "content $id",
    DateTime.utc(2022, 1, 1),
    Sender.conseiller,
    MessageType.message,
    MessageStatus.sent,
    [],
  );
}

Message _message(int date) {
  return Message(
    "uid $date",
    "content $date",
    DateTime.utc(date),
    Sender.conseiller,
    MessageType.message,
    MessageStatus.sent,
    [],
  );
}

class _MockChatRepository extends Mock implements ChatRepository {
  void onSendEventPartageSuccess(EventPartage eventPartage) {
    when(() => sendEventPartage(any(), eventPartage)).thenAnswer((_) async => true);
  }

  void onSendEventPartageFailure(EventPartage eventPartage) {
    when(() => sendEventPartage(any(), eventPartage)).thenAnswer((_) async => false);
  }

  void onPartageOffreEmploiSucceeds(OffrePartagee offrePartagee) {
    when(() => sendOffrePartagee(any(), offrePartagee)).thenAnswer((_) async => true);
  }

  void onPartageOffreEmploiFails(OffrePartagee offrePartagee) {
    when(() => sendOffrePartagee(any(), offrePartagee)).thenAnswer((_) async => false);
  }

  void onPartageEvenementEmploiSucceeds(EvenementEmploiPartage evenementEmploiPartage) {
    when(() => sendEvenementEmploiPartage(any(), evenementEmploiPartage)).thenAnswer((_) async => true);
  }

  void onPartageEvenementEmploiFails(EvenementEmploiPartage evenementEmploiPartage) {
    when(() => sendEvenementEmploiPartage(any(), evenementEmploiPartage)).thenAnswer((_) async => false);
  }

  void onPartageSessionMiloSuccess(SessionMiloPartage sessionMiloPartage) {
    when(() => sendSessionMiloPartage(any(), sessionMiloPartage)).thenAnswer((_) async => true);
  }

  void onPartageSessionMiloFails(SessionMiloPartage sessionMiloPartage) {
    when(() => sendSessionMiloPartage(any(), sessionMiloPartage)).thenAnswer((_) async => false);
  }

  void onSendMessageSuccess() {
    when(() => sendMessage(any(), any())).thenAnswer((_) async => true);
  }

  void onSendMessageFailure() {
    when(() => sendMessage(any(), any())).thenAnswer((_) async => false);
  }
}
