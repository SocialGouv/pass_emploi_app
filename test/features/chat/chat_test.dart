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
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
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

  //TODO: du refacto :)
  group("Pagination du chat", () {
    group("quand de nouveaux messages arrivent", () {
      test("on voit pour la première fois les messages", () async {
        // Given
        final repository = ChatRepositoryMock();
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 2);

        await store.dispatch(SubscribeToChatAction());

        // When
        repository.publishMessagesOnStream([_message(1), _message(2)]);

        // Then
        expect(((await newState).chatState as ChatSuccessState).messages, [_message(1), _message(2)]);
      });

      test("on voit les nouveaux messages reçus ainsi que ceux précédement reçus, ordre ASC, sans doublon", () async {
        // Given
        final repository = ChatRepositoryMock();
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 3);

        await store.dispatch(SubscribeToChatAction());
        repository.publishMessagesOnStream([_message(1), _message(2)]);

        // When
        repository.publishMessagesOnStream([_message(2), _message(3)]);

        // Then
        expect(((await newState).chatState as ChatSuccessState).messages, [_message(1), _message(2), _message(3)]);
      });

      test("on voit les nouveaux messages reçus et la pagination dans le passé, ordre ASC, sans doublon", () async {
        // Given
        final repository = ChatRepositoryMock();
        repository.oldMessagesRequested = [_message(4), _message(5), _message(6)];
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 2);
        final newOldState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 5);

        await store.dispatch(SubscribeToChatAction());
        repository.publishMessagesOnStream([_message(11), _message(12)]);
        await newState; // on ne peut pas charger le passé tant que le stream n'est pas arrivé

        // When
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(
          ((await newOldState).chatState as ChatSuccessState).messages,
          [_message(4), _message(5), _message(6), _message(11), _message(12)],
        );
      });

      test("on peut charger plusieurs fois le passé, ordre ASC, sans doublon", () async {
        // Given
        final repository = ChatRepositoryMock();
        repository.numberOfHistoryMessage = 3;
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 2);
        final newOldState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 8);

        await store.dispatch(SubscribeToChatAction());
        repository.publishMessagesOnStream([_message(11), _message(12)]);
        await newState; // on ne peut pas charger le passé tant que le stream n'est pas arrivé

        repository.oldMessagesRequested = [_message(4), _message(5), _message(6)];
        await store.dispatch(ChatRequestMorePastAction());

        // When
        repository.oldMessagesRequested = [_message(1), _message(2), _message(3)];
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(
          ((await newOldState).chatState as ChatSuccessState).messages,
          [_message(1), _message(2), _message(3), _message(4), _message(5), _message(6), _message(11), _message(12)],
        );
      });

      test("on ne peut plus charger le passé quand on arrive au début", () async {
        // Given
        final repository = ChatRepositoryMock();
        repository.numberOfHistoryMessage = 3;
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState = store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.length >= 2);

        await store.dispatch(SubscribeToChatAction());
        repository.publishMessagesOnStream([_message(11), _message(12)]);
        await newState; // on ne peut pas charger le passé tant que le stream n'est pas arrivé

        repository.oldMessagesRequested = [_message(5), _message(6)];
        await store.dispatch(ChatRequestMorePastAction());

        // When
        repository.oldMessagesRequested = [_message(3), _message(4)];
        await store.dispatch(ChatRequestMorePastAction());

        // Then
        expect(repository.numberOfOldMessagesCalled, 1);
      });

      test("on voit uniquement les nouveaux messages lorsque l'historique est cassé", () async {
        // Given
        final repository = ChatRepositoryMock();
        final store = givenState().loggedInUser().chatSuccess([]).store((f) => f.chatRepository = repository);
        final newState =
            store.onChange.firstWhere((e) => (e.chatState as ChatSuccessState).messages.contains(_message(8)));

        await store.dispatch(SubscribeToChatAction());
        repository.publishMessagesOnStream([_message(1), _message(2)]);

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
    late _MockTrackingEventRepository trackingEventRepository;
    late _MockChatRepository mockChatRepository;

    setUp(() {
      trackingEventRepository = _MockTrackingEventRepository();
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
      sut.when(() => ChatPartagerEventAction(dummyEventPartage()));

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

        // When
        await sut.dispatch();

        // Then
        trackingEventRepository.verifyHasBeenCalled();
      });
    });

    group('partage offre emploi action', () {
      sut.when(() => ChatPartagerOffreAction(dummyOffrePartagee()));

      setUpAll(() {
        registerFallbackValue(EventType.MESSAGE_EVENEMENT_EMPLOI_PARTAGE);
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

        // When
        await sut.dispatch();

        // Then
        trackingEventRepository.verifyHasBeenCalled();
      });
    });

    group('partage evenement emploi', () {
      sut.when(() => ChatPartagerEvenementEmploiAction(dummyEvenementEmploiPartage()));

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

        // When
        await sut.dispatch();

        // Then
        trackingEventRepository.verifyHasBeenCalled();
      });
    });

    group('partage session milo', () {
      sut.when(() => ChatPartagerSessionMiloAction(dummySessionMiloPartage()));

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

        // When
        await sut.dispatch();

        // Then
        trackingEventRepository.verifyHasBeenCalled();
      });
    });
  });
}

Message _mockMessage([String id = '1']) {
  return Message(
    "uid",
    "content $id",
    DateTime.utc(2022, 1, 1),
    Sender.conseiller,
    MessageType.message,
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
    [],
  );
}

class _MockTrackingEventRepository extends TrackingEventRepository {
  bool isCalled = false;

  _MockTrackingEventRepository() : super(DioMock());

  @override
  Future<bool> sendEvent({required String userId, required EventType event, required LoginMode loginMode}) async {
    isCalled = true;
    return true;
  }

  void verifyHasBeenCalled() {
    expect(isCalled, true);
  }
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
}
