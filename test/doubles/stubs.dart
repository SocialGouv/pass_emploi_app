import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import 'dummies.dart';
import 'fixtures.dart';

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
  OffreEmploiRepositorySuccessWithMoreDataStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    return OffreEmploiSearchResponse(isMoreDataAvailable: true, offres: [mockOffreEmploi()]);
  }
}

class OffreEmploiRepositoryFailureStub extends OffreEmploiRepository {
  OffreEmploiRepositoryFailureStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
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

class AuthWrapperStub extends AuthWrapper {
  late AuthTokenRequest _parameters;
  late AuthTokenResponse _result;
  late bool _throwsException;

  AuthWrapperStub() : super(DummyFlutterAppAuth());

  withArgsResolves(AuthTokenRequest parameters, result) {
    _parameters = parameters;
    _result = result;
    _throwsException = false;
  }

  withArgsThrows() {
    _throwsException = true;
  }

  @override
  Future<AuthTokenResponse> login(AuthTokenRequest request) async {
    if (_throwsException) throw Exception();
    if (request == _parameters) return this._result;
    throw Exception("Wrong parameters for stub");
  }
}
