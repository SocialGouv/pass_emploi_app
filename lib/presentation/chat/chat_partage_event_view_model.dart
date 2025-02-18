import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChatPartageEventViewModel extends Equatable {
  final DisplayState displayState;

  factory ChatPartageEventViewModel.create(Store<AppState> store) {
    return ChatPartageEventViewModel(
      displayState: _displayState(store),
    );
  }

  ChatPartageEventViewModel({required this.displayState});

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  return switch (store.state.chatPartageState) {
    ChatPartageNotInitializedState() => DisplayState.EMPTY,
    ChatPartageLoadingState() => DisplayState.LOADING,
    ChatPartageSuccessState() => DisplayState.CONTENT,
    ChatPartageFailureState() => DisplayState.FAILURE
  };
}
