import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class ConseillerProfilePageViewModel extends Equatable {
  final DisplayState displayState;
  final String sinceDate;
  final String name;

  ConseillerProfilePageViewModel({
    required this.displayState,
    this.sinceDate = "",
    this.name = "",
  });

  factory ConseillerProfilePageViewModel.create(Store<AppState> store) {
    final state = store.state.conseillerState;
    if (state is ConseillerSuccessState) {
      return ConseillerProfilePageViewModel(
        displayState: DisplayState.CONTENT,
        sinceDate: Strings.sinceDate(state.conseillerInfo.sinceDate),
        name: "${state.conseillerInfo.firstname} ${state.conseillerInfo.lastname}",
      );
    } else if (state is ConseillerLoadingState) {
      return ConseillerProfilePageViewModel(displayState: DisplayState.LOADING);
    }
    return ConseillerProfilePageViewModel(displayState: DisplayState.EMPTY);
  }

  @override
  List<Object?> get props => [displayState, sinceDate, name];
}
