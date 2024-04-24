import 'package:pass_emploi_app/features/message_informatif/message_informatif_actions.dart';
import 'package:pass_emploi_app/features/message_informatif/message_informatif_state.dart';

MessageInformatifState messageInformatifReducer(MessageInformatifState current, dynamic action) {
  if (action is MessageInformatifSuccessAction) return MessageInformatifSuccessState(message: action.result);
  return current;
}
