import 'package:pass_emploi_app/features/cv/cv_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cv_repository.dart';
import 'package:redux/redux.dart';

class CvMiddleware extends MiddlewareClass<AppState> {
  final CvRepository _repository;

  CvMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final userId = store.state.userId();

    if (userId == null) return;

    if (action is CvRequestAction) {
      store.dispatch(CvLoadingAction());
      final result = await _repository.getCvs(userId);
      if (result != null) {
        store.dispatch(CvSuccessAction(result));
      } else {
        store.dispatch(CvFailureAction());
      }
    } else if (action is CvDownloadRequestAction) {
      store.dispatch(CvDownloadLoadingAction(action.cv.url));
      final filePath = await _repository.download(url: action.cv.url, fileName: action.cv.nomFichier);
      if (filePath != null) {
        store.dispatch(CvDownloadSuccessAction(filePath, action.cv.url));
      } else {
        store.dispatch(CvDownloadFailureAction(action.cv.url));
      }
    }
  }
}
