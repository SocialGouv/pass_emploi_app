import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

abstract class PushNotificationManager {
  Future<void> init(Store<AppState> store);
  Future<String?> getToken();
  Future<void> requestPermission();
}
