import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

class ImmersionDetailsViewModel {
  final DisplayState displayState;

  ImmersionDetailsViewModel._({required this.displayState});

  factory ImmersionDetailsViewModel.create(Store<AppState> store) {
    return ImmersionDetailsViewModel._(
      displayState: displayStateFromState(store.state.immersionDetailsState),
    );
  }
}
