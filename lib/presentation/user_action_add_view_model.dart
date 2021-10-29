import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class UserActionAddViewModel {

  final Function(String? actionContent, String? actionComment) createUserAction;

  UserActionAddViewModel({required this.createUserAction});

  factory UserActionAddViewModel.create(Store<AppState> store) {
    return UserActionAddViewModel(
      createUserAction: (content, comment) => { store.dispatch(CreateUserAction(content, comment)) },
    );
  }
}