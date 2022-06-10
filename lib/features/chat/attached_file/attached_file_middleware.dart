import 'package:pass_emploi_app/features/chat/attached_file/attached_file_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/attached_file_repository.dart';
import 'package:redux/redux.dart';
import 'package:share_plus/share_plus.dart';

class AttachedFileMiddleware extends MiddlewareClass<AppState> {
  final AttachedFileRepository _repository;

  AttachedFileMiddleware(this._repository);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && (action is AttachedFileRequestAction)) {
      final path = await _repository.download(fileId: action.fileId, fileExtension: action.fileExtension);
      if (path == null || path.isEmpty) {
        store.dispatch(AttachedFileFailureAction(action.fileId));
        return;
      }
      await Share.shareFiles([path]);
      store.dispatch(AttachedFileSuccessAction(action.fileId, path));
    }
  }
}
