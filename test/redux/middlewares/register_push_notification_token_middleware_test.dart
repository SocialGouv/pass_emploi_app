import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/register_push_notification_token_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/spies.dart';

void main() {
  final _repositorySpy = RegisterTokenRepositorySpy();
  final _repositoryStub = DummyRegisterTokenRepository();

  late Store<AppState> store;

  setUp(() {
    store = Store<AppState>(reducer, initialState: AppState.initialState());
  });

  test('call should send action untouched to next middleware', () {
    final initialAction = NotLoggedInAction();

    final middleware = RegisterPushNotificationTokenMiddleware(_repositoryStub);
    final nextActionSpy = NextDispatcherSpy(expectedAction: initialAction);

    middleware.call(store, initialAction, nextActionSpy.performAction);

    expect(nextActionSpy.wasCalled, true);
  });

  test('call when action is LoginAction.success should call repository to register token', () {
    final user = User(
      id: "1",
      firstName: "first-name",
      lastName: "last-name",
      loginMode: LoginMode.MILO,
    );
    final action = LoginAction.success(user);

    final middleware = RegisterPushNotificationTokenMiddleware(_repositorySpy);

    middleware.call(store, action, (a) => {});

    expect(_repositorySpy.wasCalled, true);
  });
}

class RegisterTokenRepositorySpy extends RegisterTokenRepository {
  bool wasCalled = false;

  RegisterTokenRepositorySpy() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPushNotificationManager());

  Future<void> registerToken(String userId) async {
    expect(userId, "1");
    wasCalled = true;
  }
}
