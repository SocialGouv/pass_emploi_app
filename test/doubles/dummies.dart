import 'package:pass_emploi_app/crashlytics/Crashlytics.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/push/push_notification_manager.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/home_repository.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_creation_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';
import 'package:redux/redux.dart';

class DummyHeadersBuilder extends HeadersBuilder {}

class DummyPushNotificationManager extends PushNotificationManager {
  @override
  Future<String?> getToken() async {
    return "";
  }

  @override
  Future<void> init(Store<AppState> store) async {}
}

class DummyRegisterTokenRepository extends RegisterTokenRepository {
  DummyRegisterTokenRepository() : super("", DummyHeadersBuilder(), DummyPushNotificationManager());

  Future<void> registerToken(String userId) async {}
}

class DummyUserRepository extends UserRepository {
  DummyUserRepository() : super("", DummyHeadersBuilder());
}

class DummyHomeRepository extends HomeRepository {
  DummyHomeRepository() : super("", DummyHeadersBuilder());
}

class DummyUserActionRepository extends UserActionRepository {
  DummyUserActionRepository() : super("", DummyHeadersBuilder());
}

class DummyChatRepository extends ChatRepository {}

class DummyCrashlytics extends Crashlytics {
  @override
  void setCustomKey(String key, value) {}
}

class DummyUserActionCreationRepository extends UserActionCreationRepository {
  DummyUserActionCreationRepository() : super("", DummyHeadersBuilder());
}