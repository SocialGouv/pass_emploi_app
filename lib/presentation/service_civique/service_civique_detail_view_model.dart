import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueDetailViewModel {
  final DisplayState displayState;
  final bool shouldShowCvBottomSheet;
  final ServiceCiviqueDetail? detail;
  final ServiceCivique? serviceCivique;

  ServiceCiviqueDetailViewModel._({
    required this.displayState,
    required this.shouldShowCvBottomSheet,
    this.serviceCivique,
    this.detail,
  });

  factory ServiceCiviqueDetailViewModel.create(Store<AppState> store) {
    final ServiceCiviqueDetailState state = store.state.serviceCiviqueDetailState;
    final loginState = store.state.loginState;
    return ServiceCiviqueDetailViewModel._(
      displayState: _displayState(state),
      shouldShowCvBottomSheet: loginState is LoginSuccessState ? loginState.user.loginMode.isPe() : false,
      detail: _detail(state),
      serviceCivique: _serviceCivique(state),
    );
  }

  static ServiceCiviqueDetail? _detail(ServiceCiviqueDetailState state) {
    if (state is ServiceCiviqueDetailSuccessState) {
      return state.detail;
    }
    return null;
  }

  static ServiceCivique? _serviceCivique(ServiceCiviqueDetailState state) {
    if (state is ServiceCiviqueDetailNotFoundState) {
      return state.serviceCivique;
    }
    return null;
  }

  static DisplayState _displayState(ServiceCiviqueDetailState state) {
    if (state is ServiceCiviqueDetailLoadingState) return DisplayState.chargement;
    if (state is ServiceCiviqueDetailNotInitializedState) return DisplayState.chargement;
    if (state is ServiceCiviqueDetailFailureState) return DisplayState.erreur;
    if (state is ServiceCiviqueDetailSuccessState) return DisplayState.contenu;
    if (state is ServiceCiviqueDetailNotFoundState) return DisplayState.vide;
    return DisplayState.erreur;
  }
}
