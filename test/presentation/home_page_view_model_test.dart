import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/home_item.dart';
import 'package:pass_emploi_app/presentation/home_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:redux/redux.dart';

void main() {
  test('HomePageViewModel.create when state is loading', () {
    final state = AppState.initialState().copyWith(homeState: HomeState.loading());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isTrue);
    expect(viewModel.withFailure, isFalse);
  });

  test('HomePageViewModel.create when state is failure', () {
    final state = AppState.initialState().copyWith(homeState: HomeState.failure());
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isTrue);
  });

  test('HomePageViewModel.create when success without any content', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      actions: [],
      rendezvous: [],
    );
    final state = AppState.initialState().copyWith(homeState: HomeState.success(home));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect(viewModel.items.length, 4);
    expect((viewModel.items[0] as SectionItem).title, "Mes actions");
    expect(
      (viewModel.items[1] as MessageItem).message,
      "Tu n’as pas encore d’actions en cours.\nContacte ton conseiller pour les définir avec lui.",
    );
    expect((viewModel.items[2] as SectionItem).title, "Mes rendez-vous à venir");
    expect(
      (viewModel.items[3] as MessageItem).message,
      "Tu n’as pas de rendez-vous prévus.\nContacte ton conseiller pour prendre rendez-vous.",
    );
  });

  test('HomePageViewModel.create when success with actions', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      actions: [
        UserAction(id: '1', content: 'content1', isDone: false, lastUpdate: DateTime(2022, 12, 23, 0, 0, 0)),
        UserAction(id: '2', content: 'content2', isDone: false, lastUpdate: DateTime(2022, 12, 23, 0, 0, 0)),
      ],
      rendezvous: [],
    );
    final state = AppState.initialState().copyWith(homeState: HomeState.success(home));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[0] as SectionItem).title, "Mes actions");
    expect((viewModel.items[1] as ActionItem).action.content, 'content1');
    expect((viewModel.items[2] as ActionItem).action.content, 'content2');
    expect(viewModel.items[3] is AllActionsButton, true);
  });

  test('HomePageViewModel.create when success with rendezvous', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      actions: [],
      rendezvous: [
        Rendezvous(
          id: '1',
          date: DateTime(2022, 12, 23, 10, 20),
          title: 'title1',
          subtitle: 'subtitle1',
          comment: 'comment',
          duration: '1:00:00',
          modality: 'modality',
        ),
        Rendezvous(
          id: '2',
          date: DateTime(2022, 12, 24, 13, 40),
          title: 'title2',
          subtitle: 'subtitle2',
          comment: 'comment',
          duration: '1:00:00',
          modality: 'modality',
        )
      ],
    );
    final state = AppState.initialState().copyWith(homeState: HomeState.success(home));
    final store = Store<AppState>(reducer, initialState: state);

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[2] as SectionItem).title, "Mes rendez-vous à venir");
    final rdv1 = (viewModel.items[3] as RendezvousItem).rendezvous;
    expect(rdv1.title, 'title1');
    expect(rdv1.subtitle, 'subtitle1');
    expect(rdv1.date, '23/12/2022 à 10:20');
    final rdv2 = (viewModel.items[4] as RendezvousItem).rendezvous;
    expect(rdv2.title, 'title2');
    expect(rdv2.subtitle, 'subtitle2');
    expect(rdv2.date, '24/12/2022 à 13:40');
  });
}
