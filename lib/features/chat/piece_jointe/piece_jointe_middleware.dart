import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
import 'package:pass_emploi_app/features/chat/share_file/share_file_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/piece_jointe_repository.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class PieceJointeMiddleware extends MiddlewareClass<AppState> {
  final PieceJointeRepository _repository;

  PieceJointeMiddleware(this._repository);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState && (action is PieceJointeRequestAction)) {
      final String? path = await _repository.download(fileId: action.fileId, fileName: action.fileName);
      if (path == null || path.isEmpty) {
        store.dispatch(PieceJointeFailureAction(action.fileId));
        return;
      }
      if (path == Strings.fileNotAvailableError) {
        store.dispatch(PieceJointeUnavailableAction(action.fileId));
        return;
      }
      store.dispatch(PieceJointeSuccessAction(action.fileId));
      store.dispatch(ShareFileAction(path));
    }
  }
}
