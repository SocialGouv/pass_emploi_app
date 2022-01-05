import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/crypto/chat_crypto.dart';
import 'package:pass_emploi_app/repositories/firebase_auth_repository.dart';
import 'package:redux/src/store.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../redux/middlewares/register_push_notification_token_middleware_test.dart';
import '../utils/test_setup.dart';
import 'offre_emploi_favoris_test.dart';

main() {
  group("after login ...", () {
    final initialState = AppState.initialState().copyWith(loginState: State<User>.failure());

    test("push notification token should be registered", () {
      // Given
      final tokenRepositorySpy = RegisterTokenRepositorySpy();
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      testStoreFactory.registerTokenRepository = tokenRepositorySpy;
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      store.dispatch(LoginAction.success(mockUser(id: "1")));

      // Then
      expect(tokenRepositorySpy.wasCalled, true);
    });

    test("favoris id should be loaded", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiFavorisState is OffreEmploiFavorisLoadedState);

      // When
      store.dispatch(LoginAction.success(mockUser()));

      // Then
      final loadedFavoris = await successState;
      final favorisState = (loadedFavoris.offreEmploiFavorisState as OffreEmploiFavorisLoadedState);
      expect(favorisState.offreEmploiFavorisId, {"1", "2", "4"});
      expect(favorisState.data, null);
    });

    test("Firebase Auth token should be fetched and set", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final firebaseAuthWrapperSpy = FirebaseAuthWrapperSpy();
      testStoreFactory.firebaseAuthWrapper = firebaseAuthWrapperSpy;
      testStoreFactory.firebaseAuthRepository = FirebaseAuthRepositorySuccessStub();
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      await store.dispatch(LoginAction.success(mockUser(id: "id")));

      // Then
      expect(firebaseAuthWrapperSpy.signInWithCustomTokenHasBeenCalled, isTrue);
    });

    test("chat crypto keu should be fetched and set", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final chatCryptoSpy = _ChatCryptoSpy();
      testStoreFactory.chatCrypto = chatCryptoSpy;
      testStoreFactory.firebaseAuthRepository = FirebaseAuthRepositorySuccessStub();

      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      await store.dispatch(LoginAction.success(mockUser(id: "id")));

      // Then
      expect(chatCryptoSpy.keyWasSet, isTrue);
    });
  });
}

class FirebaseAuthRepositorySuccessStub extends FirebaseAuthRepository {
  FirebaseAuthRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<FirebaseAuthResponse?> getFirebaseAuth(String userId) async {
    if (userId == "id") return FirebaseAuthResponse("FIREBASE-TOKEN", "CLE");
    return null;
  }
}

class FirebaseAuthWrapperSpy extends FirebaseAuthWrapper {
  bool signInWithCustomTokenHasBeenCalled = false;

  @override
  Future<bool> signInWithCustomToken(String token) async {
    if (token == "FIREBASE-TOKEN") {
      signInWithCustomTokenHasBeenCalled = true;
      return true;
    }
    return false;
  }
}

class _ChatCryptoSpy extends ChatCrypto {
  bool keyWasSet = false;

  _ChatCryptoSpy() : super("");

  @override
  void setKey(String key) {
    keyWasSet = true;
  }
}