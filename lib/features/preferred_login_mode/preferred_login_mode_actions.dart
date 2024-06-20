import 'package:pass_emploi_app/models/login_mode.dart';

class PreferredLoginModeRequestAction {}

class PreferredLoginModeSuccessAction {
  final LoginMode? loginMode;

  PreferredLoginModeSuccessAction(this.loginMode);
}

class PreferredLoginModeSaveAction {
  final LoginMode loginMode;

  PreferredLoginModeSaveAction({required this.loginMode});
}
