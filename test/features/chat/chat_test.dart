import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_actions.dart';
import 'package:pass_emploi_app/features/chat/brouillon/chat_brouillon_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/tracking_analytics/tracking_event_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
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

  test('should track when an offre is successfully partagée', () async {
    // Given
    final repository = _MockTrackingEventRepository();
    final store = givenState().loggedInUser().store((factory) {
      factory.trackingEventRepository = repository;
      factory.chatRepository = ChatRepositoryStub();
    });

    // When
    await store.dispatch(ChatPartagerOffreAction(OffrePartagee(
      id: "123TZKB",
      titre: "Technicien / Technicienne d'installation de réseaux câblés  (H/F)",
      url: "https://candidat.pole-emploi.fr/offres/recherche/detail/123TZKB",
      message: "Regardes ça",
      type: OffreType.emploi,
    )));

    // Then
    expect(repository.isCalled, true);
  });
}

Message _mockMessage([String id = '1']) {
  return Message(
    "content $id",
    DateTime.utc(2022, 1, 1),
    Sender.conseiller,
    MessageType.message,
    [],
  );
}

class _MockTrackingEventRepository extends TrackingEventRepository {
  bool isCalled = false;

  _MockTrackingEventRepository() : super('', DummyHttpClient());

  @override
  Future<bool> sendEvent({required String userId, required EventType event, required LoginMode loginMode}) async {
    isCalled = true;
    return true;
  }
}
