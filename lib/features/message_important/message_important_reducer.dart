import 'package:pass_emploi_app/features/message_important/message_important_actions.dart';
import 'package:pass_emploi_app/features/message_important/message_important_state.dart';

MessageImportantState messageImportantReducer(MessageImportantState current, dynamic action) {
  if (action is MessageImportantSuccessAction) return MessageImportantSuccessState(message: action.result);
  return current;
}
