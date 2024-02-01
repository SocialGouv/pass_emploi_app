import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:redux/redux.dart';

class CvmChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<CvmEvent> messages;
  final Function(String message) onSendMessage;

  CvmChatPageViewModel({
    required this.displayState,
    required this.messages,
    required this.onSendMessage,
  });

  factory CvmChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.cvmState;
    return CvmChatPageViewModel(
      displayState: _displayState(chatState),
      messages: chatState is CvmSuccessState ? chatState.messages : [],
      onSendMessage: (String message) => store.dispatch(CvmSendMessageAction(message)),
    );
  }

  @override
  List<Object?> get props => [displayState, messages];
}

DisplayState _displayState(CvmState state) {
  if (state is ChatLoadingState) return DisplayState.LOADING;
  if (state is ChatFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}
