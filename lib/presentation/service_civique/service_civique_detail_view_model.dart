import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ServiceCiviqueDetailViewModel {
  final DisplayState displayState;
  final ServiceCiviqueDetail? detail;

  ServiceCiviqueDetailViewModel._({
    required this.displayState,
    this.detail,
  });

  factory ServiceCiviqueDetailViewModel.create(Store<AppState> store) {
    final ServiceCiviqueDetailState state = store.state.serviceCiviqueDetailState;
    return ServiceCiviqueDetailViewModel._(
      displayState: _displayState(state),
      detail: _detail(state),
    );
  }

  static ServiceCiviqueDetail? _detail(ServiceCiviqueDetailState state) {
    if (state is ServiceCiviqueDetailSuccessState) {
      return state.detail;
    }
    return null;
  }

  static DisplayState _displayState(ServiceCiviqueDetailState state) {
    if (state is ServiceCiviqueDetailLoadingState) return DisplayState.LOADING;
    if (state is ServiceCiviqueDetailNotInitializedState) return DisplayState.LOADING;
    if (state is ServiceCiviqueDetailFailureState) return DisplayState.FAILURE;
    if (state is ServiceCiviqueDetailSuccessState) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  }
}
