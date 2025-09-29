import 'package:pass_emploi_app/features/chat/piece_jointe/piece_jointe_actions.dart';
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
    final userId = store.state.userId();
    if (userId == null) return;

    if (action is PieceJointeFromIdRequestAction) {
      final String? path = await _repository.downloadFromId(fileId: action.fileId, fileName: action.fileName);
      _handleDownload(store, action.fileId, path, isImage: action.isImage);
    }

    if (action is PieceJointeFromUrlRequestAction) {
      final String? path = await _repository.downloadFromUrl(
        url: action.url,
        fileId: action.fileId,
        fileName: action.fileName,
      );
      _handleDownload(store, action.fileId, path);
    }
  }

  void _handleDownload(Store<AppState> store, String fileId, String? path, {bool isImage = false}) {
    if (path == null || path.isEmpty) {
      store.dispatch(PieceJointeFailureAction(fileId));
    } else if (path == Strings.fileNotAvailableError) {
      store.dispatch(PieceJointeUnavailableAction(fileId));
    } else {
      store.dispatch(PieceJointeSuccessAction(fileId: fileId, path: path, isImage: isImage));
    }
  }
}
