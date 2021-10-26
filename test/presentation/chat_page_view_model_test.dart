import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/presentation/chat_item.dart';
import 'package:pass_emploi_app/presentation/chat_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';
import 'package:pass_emploi_app/redux/states/chat_status_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:redux/redux.dart';

void main() {
  test('ChatPageViewModel.create when home state is not success should set default title', () {
    final state = AppState.initialState().copyWith(homeState: HomeState.failure());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.title, "Votre conseiller");
  });

  test('ChatPageViewModel.create when home state is success should set conseiller first name as title', () {
    var conseiller = Conseiller(id: "1", firstName: "Nils", lastName: "Tavernier");
    final home = Home(conseiller: conseiller, doneActionsCount: 0, actions: [], rendezvous: []);
    final state = AppState.initialState().copyWith(homeState: HomeState.success(home));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.title, "Discuter avec Nils");
  });

  test('ChatPageViewModel.create when state is loading', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.loading());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.withLoading, isTrue);
    expect(viewModel.withFailure, isFalse);
    expect(viewModel.withContent, isFalse);
  });

  test('ChatPageViewModel.create when state is failure', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.failure());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isTrue);
    expect(viewModel.withContent, isFalse);
  });

  test('ChatPageViewModel.create when state is success', () {
    final state = AppState.initialState().copyWith(chatState: ChatState.success([]));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);
    expect(viewModel.withContent, isTrue);
  });

  test('ChatPageViewModel.create when state is success and messages are of same day', () {
    final messages = [
      Message("1", DateTime.utc(2021, 1, 2, 10, 34), Sender.jeune),
      Message("2", DateTime.utc(2021, 1, 2, 11, 37), Sender.conseiller),
    ];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.items.length, 3);
    expect((viewModel.items[0] as DayItem).dayLabel, "Le 02/01/2021");
    expect((viewModel.items[1] as JeuneMessageItem).content, "1");
    expect((viewModel.items[1] as JeuneMessageItem).caption, "10:34 · Envoyé");
    expect((viewModel.items[2] as ConseillerMessageItem).content, "2");
    expect((viewModel.items[2] as ConseillerMessageItem).caption, "11:37");
  });

  test('ChatPageViewModel.create when state is success and messages are of different days', () {
    final messages = [
      Message("1", DateTime.utc(2021, 1, 2, 10, 34), Sender.jeune),
      Message("2", DateTime.utc(2021, 1, 2, 11, 37), Sender.conseiller),
      Message("3", DateTime.utc(2021, 1, 3, 13, 45), Sender.jeune),
    ];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.items.length, 5);
    expect((viewModel.items[0] as DayItem).dayLabel, "Le 02/01/2021");
    expect((viewModel.items[1] as JeuneMessageItem).content, "1");
    expect((viewModel.items[1] as JeuneMessageItem).caption, "10:34 · Envoyé");
    expect((viewModel.items[2] as ConseillerMessageItem).content, "2");
    expect((viewModel.items[2] as ConseillerMessageItem).caption, "11:37");
    expect((viewModel.items[3] as DayItem).dayLabel, "Le 03/01/2021");
    expect((viewModel.items[4] as JeuneMessageItem).content, "3");
    expect((viewModel.items[4] as JeuneMessageItem).caption, "13:45 · Envoyé");
  });

  test('ChatPageViewModel.create when state is success and messages are of today', () {
    final messages = [Message("1", DateTime.now(), Sender.jeune)];
    final state = AppState.initialState().copyWith(chatState: ChatState.success(messages));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.items.length, 2);
    expect((viewModel.items[0] as DayItem).dayLabel, "Aujourd'hui");
  });

  test('ChatPageViewModel.create when state is success and message is not red by conseiller', () {
    final messages = [Message("1", DateTime.utc(2021, 7, 2, 13, 45), Sender.jeune)];
    final state = AppState.initialState().copyWith(
      chatState: ChatState.success(messages),
      chatStatusState: ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: DateTime.utc(2021, 6, 1)),
    );
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.items.length, 2);
    expect((viewModel.items[1] as JeuneMessageItem).caption, "13:45 · Envoyé");
  });

  test('ChatPageViewModel.create when state is success and message is red by conseiller', () {
    final messages = [Message("1", DateTime.utc(2021, 7, 2, 13, 45), Sender.jeune)];
    final state = AppState.initialState().copyWith(
      chatState: ChatState.success(messages),
      chatStatusState: ChatStatusState.success(unreadMessageCount: 0, lastConseillerReading: DateTime.utc(2021, 8, 1)),
    );
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = ChatPageViewModel.create(store);

    expect(viewModel.items.length, 2);
    expect((viewModel.items[1] as JeuneMessageItem).caption, "13:45 · Lu");
  });

  test('Two view models should be equal if they have same statuses, same title, and same message count ', () {
    final chatItems = [
      JeuneMessageItem(content: "Hello !", caption: "12:00"),
      ConseillerMessageItem(content: "Yo !", caption: "12:02"),
    ];

    final firstViewModel = ChatPageViewModel(
      title: "title",
      withLoading: false,
      withFailure: false,
      withContent: true,
      items: chatItems,
      onSendMessage: (s) => {},
    );

    final secondViewModel = ChatPageViewModel(
      title: "title",
      withLoading: false,
      withFailure: false,
      withContent: true,
      items: chatItems,
      onSendMessage: (s) => {},
    );

    expect(firstViewModel == secondViewModel, true);
    expect(firstViewModel.hashCode == secondViewModel.hashCode, true);
  });

  test('Two view models should not be equal if their message count is different', () {
    final chatItems = [
      JeuneMessageItem(content: "Hello !", caption: "12:00"),
      ConseillerMessageItem(content: "Yo !", caption: "12:02"),
    ];

    final chatItemsWithNewMessage = [
      JeuneMessageItem(content: "Hello !", caption: "12:00"),
      ConseillerMessageItem(content: "Yo !", caption: "12:02"),
      JeuneMessageItem(content: "ça va ?", caption: "12:03"),
    ];

    final firstViewModel = ChatPageViewModel(
      title: "title",
      withLoading: false,
      withFailure: false,
      withContent: true,
      items: chatItems,
      onSendMessage: (s) => {},
    );

    final secondViewModel = ChatPageViewModel(
      title: "title",
      withLoading: false,
      withFailure: false,
      withContent: true,
      items: chatItemsWithNewMessage,
      onSendMessage: (s) => {},
    );

    expect(firstViewModel == secondViewModel, false);
    expect(firstViewModel.hashCode == secondViewModel.hashCode, false);
  });
}
