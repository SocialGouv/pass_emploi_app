import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/rendezvous_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:redux/redux.dart';

main() {
  test('create when user is not logged in should throw exception', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    // When / Then
    expect(() => RendezvousListPageViewModel.create(store), throwsException);
  });

  test('create when rendezvous state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(rendezvousState: RendezvousState.loading()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, true);
    expect(viewModel.withFailure, false);
  });

  test('create when rendezvous state is not initialized should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(rendezvousState: RendezvousState.notInitialized()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, true);
    expect(viewModel.withFailure, false);
  });

  test('create when rendezvous state is a failure should display failure', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(rendezvousState: RendezvousState.failure()),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, true);
  });

  test('retry, after view model was created with failure, should dispatch a RequestRendezvousAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState().copyWith(rendezvousState: RendezvousState.failure()),
    );
    final viewModel = RendezvousListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test('create when rendezvous state is success with rendezvous should display them', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(
        rendezvousState: RendezvousState.success([
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
          ),
        ]),
      ),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.items.length, 2);

    final rdv1 = viewModel.items[0];
    expect(rdv1.title, 'title1');
    expect(rdv1.subtitle, 'subtitle1');
    expect(rdv1.dateAndHour, '23/12/2022 à 10:20');
    expect(rdv1.dateWithoutHour, '23 décembre 2022');
    expect(rdv1.hourAndDuration, '10:20 (1h)');
    expect(rdv1.withComment, false);
    expect(rdv1.modality, 'Le rendez-vous se fera par téléphone.');
    final rdv2 = viewModel.items[1];
    expect(rdv2.title, 'title2');
    expect(rdv2.subtitle, 'subtitle2');
    expect(rdv2.dateAndHour, '24/12/2022 à 13:40');
    expect(rdv2.dateWithoutHour, '24 décembre 2022');
    expect(rdv2.hourAndDuration, '13:40 (30min)');
    expect(rdv2.withComment, true);
    expect(rdv2.comment, 'comment2');
    expect(rdv2.modality, 'Le rendez-vous se fera à l\'agence.');
  });

  test('create when rendezvous state is success but there are no rendezvous should display an empty message', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(rendezvousState: RendezvousState.success([])),
    );

    // When
    final viewModel = RendezvousListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, true);
    expect(viewModel.items.length, 0);
  });
}

AppState _loggedInState() {
  return AppState.initialState().copyWith(
    loginState: LoginState.loggedIn(User(
      id: "id",
      firstName: "F",
      lastName: "L",
    )),
  );
}

class StoreSpy {
  var calledWithRetry = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is RequestRendezvousAction) {
      calledWithRetry = true;
    }
    return currentState;
  }
}
