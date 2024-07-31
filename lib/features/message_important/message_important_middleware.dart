import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/message_important/message_important_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';
import 'package:redux/redux.dart';

class MessageImportantMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _chatRepository;
  final DetailsJeuneRepository _detailsJeuneRepository;

  MessageImportantMiddleware(this._chatRepository, this._detailsJeuneRepository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final loginState = store.state.loginState;
    if (loginState is! LoginSuccessState) return;

    if (action is SubscribeToChatAction) {
      final userId = loginState.user.id;
      final detailsJeune = await _detailsJeuneRepository.get(userId);
      final conseillerId = detailsJeune?.conseiller.id;
      if (conseillerId == null) return;

      final result = await _chatRepository.getMessageImportant(conseillerId);
      if (result != null) {
        store.dispatch(MessageImportantSuccessAction(result));
      }
    }
  }
}
