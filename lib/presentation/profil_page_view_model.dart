import 'package:redux/redux.dart';

import '../redux/states/app_state.dart';

class ProfilPageViewModel {
  final String userName;
  final String userEmail;

  ProfilPageViewModel({required this.userName, required this.userEmail});

  factory ProfilPageViewModel.create(Store<AppState> store) {
    final user = store.state.loginState.getResultOrThrow();
    return ProfilPageViewModel(
      userName: "${user.firstName} ${user.lastName}",
      userEmail: user.email ?? "-",
    );
  }
}
