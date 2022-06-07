import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
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
    // todo here
    if (action is RendezvousRequestAction) {
      print("--- hey");
      final path = await _repository.download("78804fad-8874-482b-89c3-beb8de508798");
      Share.shareFiles(['$path'], text: 'Cute one');
    }
  }
}