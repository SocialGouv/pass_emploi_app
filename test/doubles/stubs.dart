import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/page_actions_pe.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_pe_repository.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';
import 'package:synchronized/synchronized.dart';

import 'dummies.dart';
import 'fixtures.dart';
import 'spies.dart';

class PageActionRepositorySuccessStub extends PageActionRepository {
  Campagne? _campagne;

  PageActionRepositorySuccessStub() : super("", DummyHttpClient());

  void withCampagne(Campagne campagne) {
    _campagne = campagne;
  }

  @override
  Future<PageActions> getPageActions(String userId) async {
    return PageActions(
      actions: [
        UserAction(
          id: "id",
          content: "content",
          comment: "comment",
          status: UserActionStatus.NOT_STARTED,
          lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
          creator: JeuneActionCreator(),
        ),
      ],
      campagne: _campagne,
    );
  }

  @override
  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    return userId == "id" && content == "content" && comment == "comment" && status == UserActionStatus.NOT_STARTED;
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {}

  @override
  Future<bool> deleteUserAction(String actionId) async {
    return true;
  }
}

class PageActionRepositoryFailureStub extends PageActionRepository {
  PageActionRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<bool> createUserAction(
    String userId,
    String? content,
    String? comment,
    UserActionStatus status,
  ) async {
    return false;
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {}

  @override
  Future<bool> deleteUserAction(String actionId) async {
    return false;
  }
}

class PageActionPERepositorySuccessStub extends PageActionPERepository {
  Campagne? _campagne;

  PageActionPERepositorySuccessStub() : super("", DummyHttpClient());

  void withCampagne(Campagne campagne) {
    _campagne = campagne;
  }


  @override
  Future<PageActionsPE?> getPageActionsPE(String userId) async {
    return PageActionsPE(
      actions: [
        UserActionPE(
          id: "id",
          content: "content",
          status: UserActionPEStatus.NOT_STARTED,
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
      campagne: _campagne,
    );
  }
}

class PageActionPERepositoryFailureStub extends PageActionPERepository {
  PageActionPERepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<PageActionsPE?> getPageActionsPE(String userId) async {
    return null;
  }
}

class OffreEmploiRepositorySuccessWithMoreDataStub extends OffreEmploiRepository {
  bool? _onlyAlternance;
  int callCount = 0;

  OffreEmploiRepositorySuccessWithMoreDataStub() : super("", DummyHttpClient());

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
  OffreEmploiRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
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
    if (_throwsRefreshExpiredException) {
      throw AuthWrapperRefreshTokenExpiredException();
    }
    if (_throwsRefreshGenericException) {
      throw AuthWrapperRefreshTokenException();
    }
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
}

class ServiceCiviqueRepositorySuccessWithMoreDataStub extends ServiceCiviqueRepository {
  int callCount = 0;

  ServiceCiviqueRepositorySuccessWithMoreDataStub() : super("", DummyHttpClient());

  @override
  Future<ServiceCiviqueSearchResponse?> search({
    required String userId,
    required SearchServiceCiviqueRequest request,
    required List<ServiceCivique> previousOffers,
  }) async {
    callCount = callCount + 1;
    final response = ServiceCiviqueSearchResponse(
        isMoreDataAvailable: true,
        offres: List.from(previousOffers)..add(mockServiceCivique()),
        lastRequest: SearchServiceCiviqueRequest(
            domain: null, location: null, distance: null, startDate: null, endDate: null, page: request.page));
    return response;
  }
}

class ServiceCiviqueRepositoryFailureStub extends ServiceCiviqueRepository {
  ServiceCiviqueRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<ServiceCiviqueSearchResponse?> search({
    required String userId,
    required SearchServiceCiviqueRequest request,
    required List<ServiceCivique> previousOffers,
  }) async {
    return null;
  }
}

class ServiceCiviqueDetailRepositoryWithDataStub extends ServiceCiviqueDetailRepository {
  ServiceCiviqueDetailRepositoryWithDataStub() : super("", DummyHttpClient());

  @override
  Future<ServiceCiviqueDetailResponse> getServiceCiviqueDetail(String idOffre) async {
    return SuccessfullServiceCiviqueDetailResponse(mockServiceCiviqueDetail());
  }
}

class ServiceCiviqueDetailRepositoryWithErrorStub extends ServiceCiviqueDetailRepository {
  ServiceCiviqueDetailRepositoryWithErrorStub() : super("", DummyHttpClient());

  @override
  Future<ServiceCiviqueDetailResponse> getServiceCiviqueDetail(String idOffre) async {
    return FailedServiceCiviqueDetailResponse();
  }
}

class ImmersionRepositoryFailureStub extends ImmersionRepository {
  ImmersionRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<List<Immersion>?> search({required String userId, required SearchImmersionRequest request}) async {
    return null;
  }
}

class SuppressionCompteRepositorySuccessStub extends SuppressionCompteRepository {
  SuppressionCompteRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<bool> deleteUser(String userId) async {
    return true;
  }
}

class SuppressionCompteRepositoryFailureStub extends SuppressionCompteRepository {
  SuppressionCompteRepositoryFailureStub() : super("", DummyHttpClient());

  @override
  Future<bool> deleteUser(String userId) async {
    return false;
  }
}
