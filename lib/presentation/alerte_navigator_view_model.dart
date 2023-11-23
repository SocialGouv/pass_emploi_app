import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AlerteNavigatorViewModel extends Equatable {
  final AlerteNavigationState searchNavigationState;

  AlerteNavigatorViewModel({
    required this.searchNavigationState,
  });

  static AlerteNavigatorViewModel create(Store<AppState> store) {
    return AlerteNavigatorViewModel(
      searchNavigationState: AlerteNavigationState.fromAppState(store.state),
    );
  }

  @override
  List<Object?> get props => [searchNavigationState];
}
