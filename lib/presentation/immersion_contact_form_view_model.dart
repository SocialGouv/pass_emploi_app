import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

// TODO: onFormSubmitted => dispatch ContactImmersionRequestAction
class ImmersionContactFormViewModel extends Equatable {
  final String userEmailInitialValue;
  final String userFirstNameInitialValue;
  final String userLastNameInitialValue;
  final String messageInitialValue;

  ImmersionContactFormViewModel._({
    required this.userEmailInitialValue,
    required this.userFirstNameInitialValue,
    required this.userLastNameInitialValue,
    required this.messageInitialValue,
  });

  factory ImmersionContactFormViewModel.create(Store<AppState> store) {
    final state = store.state;
    final user = (state.loginState as LoginSuccessState).user;
    return ImmersionContactFormViewModel._(
      userEmailInitialValue: user.email ?? "",
      userFirstNameInitialValue: user.firstName,
      userLastNameInitialValue: user.lastName,
      messageInitialValue: Strings.immersitionContactFormMessageDefault,
    );
  }

  @override
  List<Object?> get props =>
      [userEmailInitialValue, userFirstNameInitialValue, userLastNameInitialValue, messageInitialValue];
}
