import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_logout_request.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import 'dummies.dart';
import 'fixtures.dart';
import 'spies.dart';

class UserActionRepositorySuccessStub extends UserActionRepository {
  UserActionRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<UserAction>?> getUserActions(String userId) async {
    return [
      UserAction(
        id: "id",
        content: "content",
        comment: "comment",
        status: UserActionStatus.NOT_STARTED,
        lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
        creator: JeuneActionCreator(),
      ),
    ];
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {}

  @override
  Future<bool> deleteUserAction(String actionId) async {
    return true;
  }
}

class UserActionRepositoryFailureStub extends UserActionRepository {
  UserActionRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<List<UserAction>?> getUserActions(String userId) async {
    return null;
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {}

  @override
  Future<bool> deleteUserAction(String actionId) async {
    return false;
  }
}

class OffreEmploiRepositorySuccessWithMoreDataStub extends OffreEmploiRepository {
  bool? _onlyAlternance;
  int callCount = 0;

  OffreEmploiRepositorySuccessWithMoreDataStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  void withOnlyAlternanceResolves(bool onlyAlternance) => _onlyAlternance = onlyAlternance;

  @override
  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
    callCount = callCount + 1;
    final response = OffreEmploiSearchResponse(isMoreDataAvailable: true, offres: [mockOffreEmploi()]);
    if (_onlyAlternance == null) return response;
    return request.onlyAlternance == _onlyAlternance ? response : null;
  }
}

class OffreEmploiRepositoryFailureStub extends OffreEmploiRepository {
  OffreEmploiRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
    return null;
  }
}

class HeadersBuilderStub extends HeadersBuilder {
  @override
  Future<Map<String, String>> headers({String? userId, String? contentType}) async {
    return {
      if (contentType != null) 'Content-Type': contentType,
    };
  }
}

class AuthenticatorLoggedInStub extends Authenticator {
  final AuthenticationMode? expectedMode;
  final String? authIdTokenLoginMode;

  AuthenticatorLoggedInStub({this.expectedMode, this.authIdTokenLoginMode})
      : super(
          DummyAuthWrapper(),
          configuration(),
          SharedPreferencesSpy(),
        );

  @override
  Future<AuthenticatorResponse> login(AuthenticationMode mode) {
    if (expectedMode == null) return Future.value(AuthenticatorResponse.SUCCESS);
    return Future.value(expectedMode == mode ? AuthenticatorResponse.SUCCESS : AuthenticatorResponse.FAILURE);
  }

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<AuthIdToken?> idToken() async => AuthIdToken(
        userId: "id",
        firstName: "F",
        lastName: "L",
        email: "first.last@milo.fr",
        expiresAt: 100000000,
        loginMode: authIdTokenLoginMode ?? "MILO",
      );
}

class AuthenticatorNotLoggedInStub extends Authenticator {
  AuthenticatorNotLoggedInStub() : super(DummyAuthWrapper(), configuration(), SharedPreferencesSpy());

  @override
  Future<AuthenticatorResponse> login(AuthenticationMode mode) => Future.value(AuthenticatorResponse.FAILURE);

  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<AuthIdToken?> idToken() async => null;
}

class AuthWrapperStub extends AuthWrapper {
  late AuthTokenRequest _loginParameters;
  late AuthLogoutRequest _logoutParameters;
  late AuthTokenResponse _loginResult;
  late AuthRefreshTokenRequest _refreshParameters;
  late AuthTokenResponse _refreshResult;
  late bool _throwsLoginException;
  late bool _throwsCanceledException = false;
  late bool _throwsLogoutException;
  late bool _throwsRefreshNetworkException;
  late bool _throwsRefreshExpiredException;
  late bool _throwsRefreshGenericException;

  AuthWrapperStub() : super(DummyFlutterAppAuth());

  withLoginArgsResolves(AuthTokenRequest parameters, AuthTokenResponse result) {
    _loginParameters = parameters;
    _loginResult = result;
    _throwsLoginException = false;
  }

  withLogoutArgsResolves(AuthLogoutRequest parameters) {
    _logoutParameters = parameters;
    _throwsLogoutException = false;
  }

  withCanceledExcption() {
    _throwsCanceledException = true;
  }

  withLoginArgsThrows() {
    _throwsLoginException = true;
  }

  withLogoutArgsThrows() {
    _throwsLogoutException = true;
  }

  withRefreshArgsThrowsNetwork() {
    _throwsRefreshNetworkException = true;
  }

  withRefreshArgsThrowsExpired() {
    _throwsRefreshNetworkException = false;
    _throwsRefreshExpiredException = true;
  }

  withRefreshArgsThrowsGeneric() {
    _throwsRefreshNetworkException = false;
    _throwsRefreshExpiredException = false;
    _throwsRefreshGenericException = true;
  }

  withRefreshArgsResolves(AuthRefreshTokenRequest parameters, AuthTokenResponse result) {
    _refreshParameters = parameters;
    _refreshResult = result;
    _throwsRefreshNetworkException = false;
    _throwsRefreshExpiredException = false;
    _throwsRefreshGenericException = false;
  }

  @override
  Future<AuthTokenResponse> login(AuthTokenRequest request) async {
    if (_throwsCanceledException) throw UserCanceledLoginException();
    if (_throwsLoginException) throw Exception();
    if (request == _loginParameters) return _loginResult;
    throw Exception("Wrong parameters for login stub");
  }

  @override
  Future<AuthTokenResponse> refreshToken(AuthRefreshTokenRequest request) async {
    if (_throwsRefreshNetworkException) throw AuthWrapperNetworkException();
    if (_throwsRefreshExpiredException) throw AuthWrapperRefreshTokenExpiredException();
    if (_throwsRefreshGenericException) throw AuthWrapperRefreshTokenException();
    if (request == _refreshParameters) return _refreshResult;
    throw Exception("Wrong parameters for refresh stub");
  }

  @override
  Future<void> logout(AuthLogoutRequest request) async {
    if (_throwsLogoutException) throw AuthWrapperLogoutException();
    if (request == _logoutParameters) return Future.value(true);
    return Future.value(false);
  }
}

class ChatRepositoryStub extends ChatRepository {
  List<Message> _messages = [];
  ConseillerMessageInfo _info = ConseillerMessageInfo(null, null);

  ChatRepositoryStub() : super(DummyChatCrypto(), DummyCrashlytics());

  void onMessageStreamReturns(List<Message> messages) => _messages = messages;

  void onChatStatusStreamReturns(ConseillerMessageInfo info) => _info = info;

  @override
  Stream<List<Message>> messagesStream(String userId) async* {
    yield _messages;
  }

  @override
  Stream<ConseillerMessageInfo> chatStatusStream(String userId) async* {
    yield _info;
  }
}
