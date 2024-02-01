import 'dart:async';

import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:synchronized/synchronized.dart';

import 'dio_mock.dart';
import 'dummies.dart';
import 'fixtures.dart';
import 'mocks.dart';
import 'spies.dart';

class PageDemarcheRepositorySuccessStub extends PageDemarcheRepository {
  PageDemarcheRepositorySuccessStub() : super(DioMock());

  @override
  Future<PageDemarches?> getPageDemarches(String userId) async {
    return PageDemarches(
      demarches: [
        Demarche(
          id: "id",
          content: "content",
          status: DemarcheStatus.NOT_STARTED,
          endDate: DateTime(2022, 12, 23, 0, 0, 0),
          deletionDate: DateTime(2022, 12, 23, 0, 0, 0),
          createdByAdvisor: true,
          label: "label",
          possibleStatus: [],
          creationDate: DateTime(2022, 12, 23, 0, 0, 0),
          modifiedByAdvisor: false,
          sousTitre: "sous titre",
          titre: "titre",
          modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
          attributs: [],
        ),
      ],
      dateDerniereMiseAJour: DateTime(2023, 1, 1),
    );
  }
}

class PageDemarcheRepositoryFailureStub extends PageDemarcheRepository {
  PageDemarcheRepositoryFailureStub() : super(DioMock());

  @override
  Future<PageDemarches?> getPageDemarches(String userId) async {
    return null;
  }
}

class AuthenticatorLoggedInStub extends Authenticator {
  final AuthenticationMode? expectedMode;
  final String? authIdTokenLoginMode;

  AuthenticatorLoggedInStub({this.expectedMode, this.authIdTokenLoginMode})
      : super(
          DummyAuthWrapper(),
          DummyLogoutRepository(),
          configuration(),
          SharedPreferencesSpy(),
        );

  @override
  Future<AuthenticatorResponse> login(AuthenticationMode mode) {
    if (expectedMode == null) {
      return Future.value(AuthenticatorResponse.SUCCESS);
    }
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
        issuedAt: 90000000,
        expiresAt: 100000000,
        loginMode: authIdTokenLoginMode ?? "MILO",
      );
}

class AuthenticatorNotLoggedInStub extends Authenticator {
  AuthenticatorNotLoggedInStub()
      : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), SharedPreferencesSpy());

  @override
  Future<AuthenticatorResponse> login(AuthenticationMode mode) => Future.value(AuthenticatorResponse.FAILURE);

  @override
  Future<bool> isLoggedIn() async => false;

  @override
  Future<AuthIdToken?> idToken() async => null;
}

class AuthWrapperStub extends AuthWrapper {
  late AuthTokenRequest _loginParameters;
  late AuthTokenResponse _loginResult;
  late AuthRefreshTokenRequest _refreshParameters;
  late AuthTokenResponse _refreshResult;
  late bool _throwsLoginException;
  late bool _throwsCanceledException = false;
  late bool _throwsRefreshNetworkException;
  late bool _throwsRefreshExpiredException;
  late bool _throwsRefreshGenericException;

  AuthWrapperStub() : super(DummyFlutterAppAuth(), Lock());

  void withLoginArgsResolves(AuthTokenRequest parameters, AuthTokenResponse result) {
    _loginParameters = parameters;
    _loginResult = result;
    _throwsLoginException = false;
  }

  void withCanceledExcption() {
    _throwsCanceledException = true;
  }

  void withLoginArgsThrows() {
    _throwsLoginException = true;
  }

  void withRefreshArgsThrowsNetwork() {
    _throwsRefreshNetworkException = true;
  }

  void withRefreshArgsThrowsExpired() {
    _throwsRefreshNetworkException = false;
    _throwsRefreshExpiredException = true;
  }

  void withRefreshArgsThrowsGeneric() {
    _throwsRefreshNetworkException = false;
    _throwsRefreshExpiredException = false;
    _throwsRefreshGenericException = true;
  }

  void withRefreshArgsResolves(AuthRefreshTokenRequest parameters, AuthTokenResponse result) {
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
}

class ChatRepositoryStub extends ChatRepository {
  List<Message> _messages = [];
  ConseillerMessageInfo _info = ConseillerMessageInfo(null, null);

  ChatRepositoryStub() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

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

  @override
  Future<bool> sendOffrePartagee(String userId, OffrePartagee offrePartagee) async {
    return true;
  }
}

class ChatRepositoryMock extends ChatRepository {
  ChatRepositoryMock() : super(DummyChatCrypto(), DummyCrashlytics(), ModeDemoRepository());

  final _streamController = StreamController<List<Message>>();
  List<Message> oldMessagesRequested = [];
  int numberOfOldMessagesCalled = 0;

  @override
  int numberOfHistoryMessage = 20;

  @override
  Stream<List<Message>> messagesStream(String userId) async* {
    await for (final messages in _streamController.stream) {
      yield messages;
    }
  }

  @override
  Future<List<Message>> oldMessages(String userId, DateTime date) async {
    numberOfOldMessagesCalled++;
    return oldMessagesRequested;
  }

  void publishMessagesOnStream(List<Message> messages) {
    _streamController.add(messages);
  }
}

class SuppressionCompteRepositorySuccessStub extends SuppressionCompteRepository {
  SuppressionCompteRepositorySuccessStub() : super(DioMock());

  @override
  Future<bool> deleteUser(String userId) async {
    return true;
  }
}

class SuppressionCompteRepositoryFailureStub extends SuppressionCompteRepository {
  SuppressionCompteRepositoryFailureStub() : super(DioMock());

  @override
  Future<bool> deleteUser(String userId) async {
    return false;
  }
}

class PieceJointeRepositorySuccessStub extends PieceJointeRepository {
  PieceJointeRepositorySuccessStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return "$fileId-path";
  }
}

class PieceJointeRepositoryFailureStub extends PieceJointeRepository {
  PieceJointeRepositoryFailureStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return null;
  }
}

class PieceJointeRepositoryUnavailableStub extends PieceJointeRepository {
  PieceJointeRepositoryUnavailableStub() : super(DioMock(), MockPieceJointeSaver());

  @override
  Future<String?> download({required String fileId, required String fileName}) async {
    return "ERROR: 404";
  }
}

class ActionCommentaireRepositorySuccessStub extends ActionCommentaireRepository {
  ActionCommentaireRepositorySuccessStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    return mockCommentaires();
  }
}

class ActionCommentaireRepositoryFailureStub extends ActionCommentaireRepository {
  ActionCommentaireRepositoryFailureStub() : super(DioMock(), DummyPassEmploiCacheManager());

  @override
  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    return null;
  }
}

class UpdateDemarcheRepositorySuccessStub extends UpdateDemarcheRepository {
  String? _userId;
  String? _actionId;
  DemarcheStatus? _status;
  DateTime? _fin;
  DateTime? _debut;

  UpdateDemarcheRepositorySuccessStub() : super(DioMock());

  void withArgsResolves(
    String userId,
    String actionId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) {
    _userId = userId;
    _actionId = actionId;
    _status = status;
    _fin = dateFin;
    _debut = dateDebut;
  }

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    if (_userId == userId && _actionId == demarcheId && _status == status && _debut == dateDebut && _fin == dateFin) {
      return mockDemarche(id: demarcheId, status: status);
    }
    return null;
  }
}

class UpdateDemarcheRepositoryFailureStub extends UpdateDemarcheRepository {
  UpdateDemarcheRepositoryFailureStub() : super(DioMock());

  @override
  Future<Demarche?> updateDemarche(
    String userId,
    String demarcheId,
    DemarcheStatus status,
    DateTime? dateFin,
    DateTime? dateDebut,
  ) async {
    return null;
  }
}
