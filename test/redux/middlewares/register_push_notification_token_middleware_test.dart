import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:redux/redux.dart';

void main() {
  final _repositorySpy = RegisterTokenRepositorySpy();
  final _repositoryStub = RegisterTokenRepositoryStub();

  test('call should send action untouched to next middleware', () {
    final store = Store<AppState>(reducer, initialState: AppState.initialState());
    var initialAction = NotLoggedInAction();

    final middleware = RegisterPushNotificationTokenMiddleware(_repositoryStub);
    final nextActionSpy = NextDispatcherSpy(expectedAction: initialAction);

    middleware.call(store, initialAction, nextActionSpy.performAction);

    expect(nextActionSpy.wasCalled, true);
  });

  test('call when action is LoggedInAction should call repository to register token', () {
    final store = Store<AppState>(reducer, initialState: AppState.initialState());
    final user = User(id: "1", firstName: "first-name", lastName: "last-name");
    var action = LoggedInAction(user);

    final middleware = RegisterPushNotificationTokenMiddleware(_repositorySpy);

    middleware.call(store, action, (a) => {});

    expect(_repositorySpy.wasCalled, true);
  });
}

class RegisterTokenRepositorySpy extends RegisterTokenRepository {
  bool wasCalled = false;

  RegisterTokenRepositorySpy() : super("", DummyHeadersBuilder(), DummyPushNotificationManager());

  Future<void> registerToken(String userId) async {
    expect(userId, "1");
    wasCalled = true;
  }
}

class RegisterTokenRepositoryStub extends RegisterTokenRepository {
  RegisterTokenRepositoryStub() : super("", DummyHeadersBuilder(), DummyPushNotificationManager());

  Future<void> registerToken(String userId) async {}
}

class DummyHeadersBuilder extends HeadersBuilder {}

class DummyPushNotificationManager extends PushNotificationManager {
  @override
  Future<String?> getToken() async {
    return "";
  }

  @override
  Future<void> init(Store<AppState> store) async {}
}

class NextDispatcherSpy {
  bool wasCalled = false;
  late final dynamic _expectedAction;

  NextDispatcherSpy({dynamic expectedAction}) {
    _expectedAction = expectedAction;
  }

  dynamic performAction(dynamic action) {
    expect(_expectedAction, action);
    wasCalled = true;
  }
}
