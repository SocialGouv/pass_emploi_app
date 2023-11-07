import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
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
    final state = store.state.detailsJeuneState;
    if (state is SuccessState<DetailsJeune>) {
      return ConseillerProfilePageViewModel(
        displayState: DisplayState.CONTENT,
        sinceDate: Strings.sinceDate(state.data.conseiller.sinceDate.toDay()),
        name: "${state.data.conseiller.firstname} ${state.data.conseiller.lastname}",
      );
    } else if (state is LoadingState) {
      return ConseillerProfilePageViewModel(displayState: DisplayState.LOADING);
    }
    return ConseillerProfilePageViewModel(displayState: DisplayState.EMPTY);
  }

  @override
  List<Object?> get props => [displayState, sinceDate, name];
}
