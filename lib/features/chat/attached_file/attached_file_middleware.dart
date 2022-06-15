import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/attached_file_repository.dart';
import 'package:redux/redux.dart';

class AttachedFileMiddleware extends MiddlewareClass<AppState> {
  final AttachedFileRepository _repository;

  AttachedFileMiddleware(this._repository);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && (action is AttachedFileRequestAction)) {
      final String? path = await _repository.download(fileId: action.fileId, fileExtension: action.fileExtension);
      if (path == null || path.isEmpty) {
        store.dispatch(AttachedFileFailureAction(action.fileId));
        return;
      }
      store.dispatch(AttachedFileSuccessAction(action.fileId));
      store.dispatch(ShareFileAction(path));
    }
  }
}
