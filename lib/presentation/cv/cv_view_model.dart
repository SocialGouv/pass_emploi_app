import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';
import 'package:pass_emploi_app/models/cv_pole_emploi.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CvViewModel extends Equatable {
  final List<CvPoleEmploi> cvList;
  final DisplayState displayState;
  final Function() retry;
  final Function(CvPoleEmploi) onDownload;

  CvViewModel({required this.displayState, required this.retry, required this.cvList, required this.onDownload});

  factory CvViewModel.create(Store<AppState> store) {
    final state = store.state.cvState;
    return CvViewModel(
      cvList: _cvList(state),
      displayState: _displayState(store),
      retry: () => store.dispatch(CvRequestAction()),
      onDownload: (cv) => store.dispatch(CvdownldRequestAction(cv)),
    );
  }

  @override
  List<Object?> get props => [cvList, displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final cvState = store.state.cvState;
  if (cvState is CvSuccessState) {
    return cvState.cvList!.isEmpty ? DisplayState.EMPTY : DisplayState.CONTENT;
  }
  if (cvState is CvFailureState) return DisplayState.FAILURE;
  return DisplayState.LOADING;
}

List<CvPoleEmploi> _cvList(CvState state) {
  if (state is CvSuccessState) return state.cvList!;
  return [];
}
