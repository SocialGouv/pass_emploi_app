import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ConseillerProfilePageViewModel extends Equatable {
  final DisplayState displayState;
  final String sinceDate;
  final String name;
  final String sinceDateA11y;

  ConseillerProfilePageViewModel({
    required this.displayState,
    this.sinceDate = "",
    this.name = "",
    this.sinceDateA11y = "",
  });

  factory ConseillerProfilePageViewModel.create(Store<AppState> store) {
    final state = store.state.detailsJeuneState;
    if (state is DetailsJeuneSuccessState) {
      return ConseillerProfilePageViewModel(
        displayState: DisplayState.CONTENT,
        sinceDate: Strings.sinceDate(state.detailsJeune.conseiller.sinceDate.toDay()),
        sinceDateA11y: Strings.sinceDate(state.detailsJeune.conseiller.sinceDate.formatDateToFrench()),
        name: "${state.detailsJeune.conseiller.firstname} ${state.detailsJeune.conseiller.lastname}",
      );
    } else if (state is DetailsJeuneLoadingState) {
      return ConseillerProfilePageViewModel(displayState: DisplayState.LOADING);
    }
    return ConseillerProfilePageViewModel(displayState: DisplayState.EMPTY);
  }

  @override
  List<Object?> get props => [displayState, sinceDate, name];
}
