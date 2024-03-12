import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ProfilPageViewModel extends Equatable {
  final String userName;
  final String userEmail;
  final bool displayMonConseiller;
  final bool displayDeveloperOptions;
  final bool withDownloadCv;
  final Function() onTitleTap;

  ProfilPageViewModel({
    required this.userName,
    required this.userEmail,
    required this.displayMonConseiller,
    required this.displayDeveloperOptions,
    required this.withDownloadCv,
    required this.onTitleTap,
  });

  factory ProfilPageViewModel.create(Store<AppState> store) {
    final state = store.state.loginState;
    final user = state is LoginSuccessState ? state.user : null;
    return ProfilPageViewModel(
      userName: user != null ? "${user.firstName} ${user.lastName}" : "",
      userEmail: user?.email ?? Strings.missingEmailAddressValue,
      displayMonConseiller: _shouldDisplayMonConseiller(store.state.detailsJeuneState),
      displayDeveloperOptions: store.state.developerOptionsState is DeveloperOptionsActivatedState,
      withDownloadCv: user?.loginMode.isPe() ?? false,
      onTitleTap: () => store.dispatch(DeveloperOptionsActivationRequestAction()),
    );
  }

  static bool _shouldDisplayMonConseiller(DetailsJeuneState? state) {
    if (state == null || state is DetailsJeuneNotInitializedState) return false;
    return true;
  }

  @override
  List<Object?> get props => [
        userName,
        userEmail,
        displayMonConseiller,
        displayDeveloperOptions,
        withDownloadCv,
      ];
}
