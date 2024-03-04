import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';

sealed class PreferredLoginModeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PreferredLoginModeNotInitializedState extends PreferredLoginModeState {}

class PreferredLoginModeSuccessState extends PreferredLoginModeState {
  final LoginMode? loginMode;

  PreferredLoginModeSuccessState(this.loginMode);

  @override
  List<Object?> get props => [loginMode];
}
