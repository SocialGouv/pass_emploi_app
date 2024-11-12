import 'package:pass_emploi_app/features/date_consultation_offre/date_derniere_consultation_store_extension.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
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
  final DateTime? dateDerniereConsultation;

  ServiceCiviqueDetailViewModel._({
    required this.displayState,
    required this.shouldShowCvBottomSheet,
    this.serviceCivique,
    this.detail,
    this.dateDerniereConsultation,
  });

  factory ServiceCiviqueDetailViewModel.create(Store<AppState> store) {
    final ServiceCiviqueDetailState state = store.state.serviceCiviqueDetailState;
    final loginState = store.state.loginState;
    final detail = _detail(state);
    return ServiceCiviqueDetailViewModel._(
      displayState: _displayState(state),
      shouldShowCvBottomSheet: loginState is LoginSuccessState ? loginState.user.loginMode.isPe() : false,
      detail: detail,
      serviceCivique: _serviceCivique(state),
      dateDerniereConsultation: store.getOffreDateDerniereConsultationOrNull(detail?.id ?? ""),
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
    if (state is ServiceCiviqueDetailLoadingState) return DisplayState.LOADING;
    if (state is ServiceCiviqueDetailNotInitializedState) return DisplayState.LOADING;
    if (state is ServiceCiviqueDetailFailureState) return DisplayState.FAILURE;
    if (state is ServiceCiviqueDetailSuccessState) return DisplayState.CONTENT;
    if (state is ServiceCiviqueDetailNotFoundState) return DisplayState.EMPTY;
    return DisplayState.FAILURE;
  }
}
