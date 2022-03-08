import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:redux/redux.dart';

import '../redux/app_state.dart';
import '../ui/strings.dart';

class ProfilPageViewModel extends Equatable {
  final String userName;
  final String userEmail;

  ProfilPageViewModel({required this.userName, required this.userEmail});

  factory ProfilPageViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    return ProfilPageViewModel(
      userName: user != null ? "${user.firstName} ${user.lastName}" : "",
      userEmail: user?.email ?? Strings.missingEmailAddressValue,
    );
  }

  @override
  List<Object?> get props => [userName, userEmail];
}
