import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/favoris_state.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:redux/src/store.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../redux/middlewares/register_push_notification_token_middleware_test.dart';
import '../utils/test_setup.dart';
import 'favoris/offre_emploi_favoris_test.dart';

main() {
  group("after login ...", () {
    final initialState = AppState.initialState().copyWith(loginState: LoginFailureState());

    test("push notification token should be registered", () async {
      // Given
      final tokenRepositorySpy = RegisterTokenRepositorySpy();
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      testStoreFactory.registerTokenRepository = tokenRepositorySpy;
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      await store.dispatch(LoginSuccessAction(mockUser(id: "1")));

      // Then
      expect(tokenRepositorySpy.wasCalled, true);
    });

    test("favoris id should be loaded", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      final successState =
          store.onChange.firstWhere((e) => e.offreEmploiFavorisState is FavorisLoadedState<OffreEmploi>);

      // When
      store.dispatch(LoginSuccessAction(mockUser()));

      // Then
      final loadedFavoris = await successState;
      final favorisState = (loadedFavoris.offreEmploiFavorisState as FavorisLoadedState<OffreEmploi>);
      expect(favorisState.favorisId, {"1", "2", "4"});
      expect(favorisState.data, null);
    });

    group('when coming from a chat deep link…', () {
      final initialState = AppState.initialState().copyWith(
        loginState: LoginFailureState(),
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.now()),
      );

      test(
          "Firebase Auth token should be fetched and set synchronously to properly prepare ChatPage to be the first opened page",
          () async {
        // Given
            final factory = TestStoreFactory();
        final firebaseAuthWrapperSpy = _FirebaseAuthWrapperSpy();
        factory.firebaseAuthWrapper = firebaseAuthWrapperSpy;
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> newState = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        await newState;
        expect(firebaseAuthWrapperSpy.signInWithCustomTokenHasBeenCalled, isTrue);
      });

      test("chat crypto key should be fetched and set  to properly prepare ChatPage to be the first opened page",
          () async {
        // Given
            final factory = TestStoreFactory();
        final chatCryptoSpy = _ChatCryptoSpy();
        factory.chatCrypto = chatCryptoSpy;
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> newState = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        await newState;
        expect(chatCryptoSpy.keyWasSet, isTrue);
      });

      test("chat status should be subscribed", () async {
        // Given
        final factory = TestStoreFactory();
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        factory.chatRepository = ChatRepositoryStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> result = store.onChange.firstWhere((e) {
          return e.chatStatusState is ChatStatusEmptyState;
        });

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        final AppState resultState = await result;
        expect(resultState.chatStatusState is ChatStatusEmptyState, isTrue);
      });
    });

    group('when not coming from a chat deep link…', () {
      final initialState = AppState.initialState().copyWith(
        loginState: LoginFailureState(),
        deepLinkState: DeepLinkState(DeepLink.NOT_SET, DateTime.now()),
      );

      test("Firebase Auth token should be fetched and set asynchronously to accelerate sign-in process", () async {
        // Given
        final factory = TestStoreFactory();
        final firebaseAuthWrapperSpy = _FirebaseAuthWrapperSpy();
        factory.firebaseAuthWrapper = firebaseAuthWrapperSpy;
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> newState = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        await newState;
        expect(firebaseAuthWrapperSpy.signInWithCustomTokenHasBeenCalled, isFalse);
        // Wait some delay to ensure token is eventually properly set
        await Future.delayed(Duration(milliseconds: 200));
        expect(firebaseAuthWrapperSpy.signInWithCustomTokenHasBeenCalled, isTrue);
      });

      test("chat crypto key should be fetched and set to properly prepare ChatPage to accelerate sign-in process",
          () async {
        // Given
            final factory = TestStoreFactory();
        final chatCryptoSpy = _ChatCryptoSpy();
        factory.chatCrypto = chatCryptoSpy;
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> newState = store.onChange.firstWhere((e) => e.loginState is LoginSuccessState);

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        await newState;
        expect(chatCryptoSpy.keyWasSet, isFalse);
        // Wait some delay to ensure chat crypto is eventually properly set
        await Future.delayed(Duration(milliseconds: 200));
        expect(chatCryptoSpy.keyWasSet, isTrue);
      });

      test("chat status should be subscribed", () async {
        // Given
        final factory = TestStoreFactory();
        factory.firebaseAuthRepository = _FirebaseAuthRepositorySuccessStub();
        factory.chatRepository = ChatRepositoryStub();
        final Store<AppState> store = factory.initializeReduxStore(initialState: initialState);
        final Future<AppState> result = store.onChange.firstWhere((e) {
          return e.chatStatusState is ChatStatusEmptyState;
        });

        // When
        store.dispatch(LoginSuccessAction(mockUser(id: "id")));

        // Then
        final AppState resultState = await result;
        expect(resultState.chatStatusState is ChatStatusEmptyState, isTrue);
      });
    });
  });
}

class _FirebaseAuthRepositorySuccessStub extends FirebaseAuthRepository {
  _FirebaseAuthRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<FirebaseAuthResponse?> getFirebaseAuth(String userId) async {
    if (userId == "id") return FirebaseAuthResponse("FIREBASE-TOKEN", "CLE");
    return null;
  }
}

class _FirebaseAuthWrapperSpy extends FirebaseAuthWrapper {
  bool signInWithCustomTokenHasBeenCalled = false;

  @override
  Future<bool> signInWithCustomToken(String token) async {
    if (token == "FIREBASE-TOKEN") {
      signInWithCustomTokenHasBeenCalled = true;
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {}
}

class _ChatCryptoSpy extends ChatCrypto {
  bool keyWasSet = false;

  @override
  void setKey(String key) {
    keyWasSet = true;
  }
}
