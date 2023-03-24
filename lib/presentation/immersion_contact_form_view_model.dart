import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ImmersionContactFormViewModel extends Equatable {
  final String userEmail;
  final String userFirstName;
  final String userLastName;

  ImmersionContactFormViewModel._({
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
  });

  factory ImmersionContactFormViewModel.create(Store<AppState> store) {
    final state = store.state;
    final user = (state.loginState as LoginSuccessState).user;
    return ImmersionContactFormViewModel._(
      userEmail: user.email ?? "",
      userFirstName: user.firstName,
      userLastName: user.lastName,
    );
  }

  @override
  List<Object?> get props => [userEmail, userFirstName, userLastName];
}
