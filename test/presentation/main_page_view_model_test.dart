import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/main_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:redux/redux.dart';

void main() {
  test('MainPageViewModel.create when chat status state is not initialized should not display chat badge', () {
    final state = AppState.initialState().copyWith(chatStatusState: ChatStatusState.notInitialized());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = MainPageViewModel.create(store);

    expect(viewModel.withChatBadge, false);
  });

  test('MainPageViewModel.create when chat status state is empty should not display chat badge', () {
    final state = AppState.initialState().copyWith(chatStatusState: ChatStatusState.empty());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = MainPageViewModel.create(store);

    expect(viewModel.withChatBadge, false);
  });

  test(
      'MainPageViewModel.create when chat status state is success without unread message should not display chat badge',
      () {
    final state = AppState.initialState().copyWith(
      chatStatusState: ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: DateTime.now()),
    );
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = MainPageViewModel.create(store);

    expect(viewModel.withChatBadge, false);
  });

  test('MainPageViewModel.create when chat status state is success with unread message should display chat badge', () {
    final state = AppState.initialState().copyWith(
      chatStatusState: ChatStatusState.success(unreadMessageCount: 1, lastConseillerReading: DateTime.now()),
    );
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = MainPageViewModel.create(store);

    expect(viewModel.withChatBadge, true);
  });
}
