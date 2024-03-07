import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/models/cvm/cvm_event.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class CvmChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<CvmEvent> messages;
  final Function(String message) onSendMessage;
  final Function() onRetry;
  final Function() onLoadMore;

  CvmChatPageViewModel({
    required this.displayState,
    required this.messages,
    required this.onSendMessage,
    required this.onRetry,
    required this.onLoadMore,
  });

  factory CvmChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.cvmState;
    return CvmChatPageViewModel(
      displayState: _displayState(chatState),
      messages: chatState is CvmSuccessState ? chatState.messages : [],
      onSendMessage: (String message) => store.dispatch(CvmSendMessageAction(message)),
      onRetry: () => store.dispatch(CvmRequestAction()),
      onLoadMore: () => store.dispatch(CvmLoadMoreAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, messages];
}

DisplayState _displayState(CvmState state) {
  if (state is CvmNotInitializedState) return DisplayState.LOADING;
  if (state is CvmLoadingState) return DisplayState.LOADING;
  if (state is CvmFailureState) return DisplayState.FAILURE;
  if (state is CvmSuccessState && state.messages.isEmpty) return DisplayState.EMPTY;
  return DisplayState.CONTENT;
}
