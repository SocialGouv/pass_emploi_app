import 'package:pass_emploi_app/auth/auth_id_token.dart';

class PreferredLoginModeRequestAction {}

class PreferredLoginModeSuccessAction {
  final LoginMode? loginMode;

  PreferredLoginModeSuccessAction(this.loginMode);
}

class PreferredLoginModeSaveAction {
  final LoginMode loginMode;

  PreferredLoginModeSaveAction({required this.loginMode});
}
