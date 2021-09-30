import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/home_item.dart';
import 'package:pass_emploi_app/presentation/home_page_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:redux/redux.dart';

void main() {
  test('HomePageViewModel.create when user is not logged in throws exception', () {
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    expect(() => HomePageViewModel.create(store), throwsException);
  });

  test('HomePageViewModel.create when state is loading', () {
    final store = _store(HomeState.loading());

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isTrue);
    expect(viewModel.withFailure, isFalse);
  });

  test('HomePageViewModel.create when state is failure', () {
    final store = _store(HomeState.failure());

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isTrue);
  });

  test('HomePageViewModel.create when success without any actions and not any action done', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      doneActionsCount: 0,
      actions: [],
      rendezvous: [],
    );
    final store = _store(HomeState.success(home));

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[0] as SectionItem).title, "Mes actions");
    expect(
      (viewModel.items[1] as MessageItem).message,
      "Tu n’as pas encore d’actions en cours.\nContacte ton conseiller pour les définir avec lui.",
    );
  });

  test('HomePageViewModel.create when success without any actions but some actions done', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      doneActionsCount: 1,
      actions: [],
      rendezvous: [],
    );
    final store = _store(HomeState.success(home));

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[0] as SectionItem).title, "Mes actions");
    expect(
      (viewModel.items[1] as MessageItem).message,
      "Bravo :) Tu n’as plus d’actions en cours.\nContacte ton conseiller pour obtenir de nouvelles actions.",
    );
    expect(viewModel.items[2] is AllActionsButtonItem, true);
  });

  test('HomePageViewModel.create when success with actions', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      doneActionsCount: 0,
      actions: [
        UserAction(
          id: '1',
          content: 'content1',
          comment: 'comment1',
          isDone: false,
          lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
        ),
        UserAction(
          id: '2',
          content: 'content2',
          comment: 'comment2',
          isDone: false,
          lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
        ),
      ],
      rendezvous: [],
    );
    final store = _store(HomeState.success(home));

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[0] as SectionItem).title, "Mes actions");
    expect((viewModel.items[1] as ActionItem).action.content, 'content1');
    expect((viewModel.items[1] as ActionItem).action.comment, 'comment1');
    expect((viewModel.items[2] as ActionItem).action.content, 'content2');
    expect((viewModel.items[2] as ActionItem).action.comment, 'comment2');
    expect(viewModel.items[3] is AllActionsButtonItem, true);
  });

  test('HomePageViewModel.create when success without any rendezvous', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      doneActionsCount: 0,
      actions: [],
      rendezvous: [],
    );
    final store = _store(HomeState.success(home));

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[2] as SectionItem).title, "Mes rendez-vous à venir");
    expect(
      (viewModel.items[3] as MessageItem).message,
      "Tu n’as pas de rendez-vous prévus.\nContacte ton conseiller pour prendre rendez-vous.",
    );
  });

  test('HomePageViewModel.create when success with rendezvous', () {
    final home = Home(
      conseiller: Conseiller(id: '1', firstName: 'first', lastName: 'last'),
      actions: [],
      doneActionsCount: 0,
      rendezvous: [
        Rendezvous(
          id: '1',
          date: DateTime(2022, 12, 23, 10, 20),
          title: 'title1',
          subtitle: 'subtitle1',
          comment: '',
          duration: '1:00:00',
          modality: 'Par téléphone',
        ),
        Rendezvous(
          id: '2',
          date: DateTime(2022, 12, 24, 13, 40),
          title: 'title2',
          subtitle: 'subtitle2',
          comment: 'comment2',
          duration: '0:30:00',
          modality: 'À l\'agence',
        )
      ],
    );
    final store = _store(HomeState.success(home));

    final viewModel = HomePageViewModel.create(store);

    expect(viewModel.withLoading, isFalse);
    expect(viewModel.withFailure, isFalse);

    expect((viewModel.items[2] as SectionItem).title, "Mes rendez-vous à venir");
    final rdv1 = (viewModel.items[3] as RendezvousItem).rendezvous;
    expect(rdv1.title, 'title1');
    expect(rdv1.subtitle, 'subtitle1');
    expect(rdv1.dateAndHour, '23/12/2022 à 10:20');
    expect(rdv1.dateWithoutHour, '23 décembre 2022');
    expect(rdv1.hourAndDuration, '10:20 (1h)');
    expect(rdv1.withComment, false);
    expect(rdv1.modality, 'Le rendez-vous se fera par téléphone.');
    final rdv2 = (viewModel.items[4] as RendezvousItem).rendezvous;
    expect(rdv2.title, 'title2');
    expect(rdv2.subtitle, 'subtitle2');
    expect(rdv2.dateAndHour, '24/12/2022 à 13:40');
    expect(rdv2.dateWithoutHour, '24 décembre 2022');
    expect(rdv2.hourAndDuration, '13:40 (30min)');
    expect(rdv2.withComment, true);
    expect(rdv2.comment, 'comment2');
    expect(rdv2.modality, 'Le rendez-vous se fera à l\'agence.');
  });
}

_store(HomeState homeState) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      loginState: LoginState.loggedIn(User(id: '', firstName: '', lastName: '')),
      homeState: homeState,
    ),
  );
}
