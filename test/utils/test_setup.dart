import 'package:pass_emploi_app/crashlytics/Crashlytics.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/store_factory.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

import '../doubles/dummies.dart';

class TestStoreFactory {
  UserRepository userRepository = DummyUserRepository();
  HomeRepository homeRepository = DummyHomeRepository();
  UserActionRepository userActionRepository = DummyUserActionRepository();
  ChatRepository chatRepository = DummyChatRepository();
  RegisterTokenRepository registerTokenRepository = DummyRegisterTokenRepository();
  Crashlytics crashlytics = DummyCrashlytics();

  Store<AppState> initializeReduxStore({required AppState initialState}) {
    return StoreFactory(
      userRepository,
      homeRepository,
      userActionRepository,
      chatRepository,
      registerTokenRepository,
      crashlytics,
    ).initializeReduxStore(initialState: initialState);
  }
}
