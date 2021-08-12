import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:redux/redux.dart';

void main() {
  test('ChatViewModel.create when state is loading', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.loading());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.withLoading, isTrue);
    expect(viewModel.withFailure, isFalse);
    expect(viewModel.withContent, isFalse);
  });

  test('ChatViewModel.create when state is failure', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.failure());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isTrue);
    expect(viewModel.withContent, isFalse);
  });

  test('ChatViewModel.create when state is success', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.success([]));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);
    expect(viewModel.withContent, isTrue);
  });

  test('ChatViewModel.create when state is success and messages are of same day', () {
    final messages = [
      Message("1", DateTime.utc(2021, 1, 2, 10, 34), Sender.jeune),
      Message("2", DateTime.utc(2021, 1, 2, 11, 37), Sender.conseiller),
    ];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.items.length, 3);
    expect((viewModel.items[0] as DayItem).dayLabel, "Le 02/01/2021");
    expect((viewModel.items[1] as JeuneMessageItem).content, "1");
    expect((viewModel.items[1] as JeuneMessageItem).hourLabel, "à 10:34");
    expect((viewModel.items[2] as ConseillerMessageItem).content, "2");
    expect((viewModel.items[2] as ConseillerMessageItem).hourLabel, "à 11:37");
  });

  test('ChatViewModel.create when state is success and messages are of different days', () {
    final messages = [
      Message("1", DateTime.utc(2021, 1, 2, 10, 34), Sender.jeune),
      Message("2", DateTime.utc(2021, 1, 2, 11, 37), Sender.conseiller),
      Message("3", DateTime.utc(2021, 1, 3, 13, 45), Sender.jeune),
    ];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.items.length, 5);
    expect((viewModel.items[0] as DayItem).dayLabel, "Le 02/01/2021");
    expect((viewModel.items[1] as JeuneMessageItem).content, "1");
    expect((viewModel.items[1] as JeuneMessageItem).hourLabel, "à 10:34");
    expect((viewModel.items[2] as ConseillerMessageItem).content, "2");
    expect((viewModel.items[2] as ConseillerMessageItem).hourLabel, "à 11:37");
    expect((viewModel.items[3] as DayItem).dayLabel, "Le 03/01/2021");
    expect((viewModel.items[4] as JeuneMessageItem).content, "3");
    expect((viewModel.items[4] as JeuneMessageItem).hourLabel, "à 13:45");
  });

  test('ChatViewModel.create when state is success and messages are of today', () {
    final messages = [Message("1", DateTime.now(), Sender.jeune)];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatViewModel.create(store);

    expect(viewModel.items.length, 2);
    expect((viewModel.items[0] as DayItem).dayLabel, "Aujourd'hui");
  });
}
