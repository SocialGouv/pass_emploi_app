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
  final DisplayState Function(String url) downloadStatus;
  final Function() retry;
  final Function(CvPoleEmploi) onDownload;

  CvViewModel({
    required this.displayState,
    required this.retry,
    required this.cvList,
    required this.onDownload,
    required this.downloadStatus,
  });

  factory CvViewModel.create(Store<AppState> store) {
    final state = store.state.cvState;
    final cvSuccessState = state is CvSuccessState ? state : null;
    return CvViewModel(
      cvList: _cvList(state),
      displayState: _displayState(store),
      downloadStatus: (url) => _downloadStatus(url, cvSuccessState),
      retry: () => store.dispatch(CvRequestAction()),
      onDownload: (cv) => store.dispatch(CvDownloadRequestAction(cv)),
    );
  }

  @override
  List<Object?> get props => [cvList, displayState, downloadStatus];
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

DisplayState _downloadStatus(String url, CvSuccessState? cvSuccessState) {
  if (cvSuccessState == null) return DisplayState.CONTENT;
  final status = cvSuccessState.cvDownloadStatus[url];
  switch (status) {
    case null:
    case CvDownloadStatus.failure:
    case CvDownloadStatus.success:
      return DisplayState.CONTENT;
    case CvDownloadStatus.loading:
      return DisplayState.LOADING;
  }
}
