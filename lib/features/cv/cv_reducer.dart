import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/features/cv/cv_state.dart';

CvState cvReducer(CvState current, dynamic action) {
  if (action is CvLoadingAction) return CvLoadingState();
  if (action is CvFailureAction) return CvFailureState();
  if (action is CvSuccessAction) return CvSuccessState(cvList: action.cvList, cvDownloadStatus: {});
  if (action is CvResetAction) return CvNotInitializedState();
  if (action is CvDownloadLoadingAction && current is CvSuccessState) {
    return current.updateDownloadStatus(action.url, CvDownloadStatus.loading);
  }
  if (action is CvDownloadSuccessAction && current is CvSuccessState) {
    return current.updateDownloadStatus(action.url, CvDownloadStatus.success);
  }
  if (action is CvDownloadFailureAction && current is CvSuccessState) {
    return current.updateDownloadStatus(action.url, CvDownloadStatus.failure);
  }
  return current;
}
