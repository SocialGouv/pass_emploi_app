import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/profil/profil_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create should properly set user info", () {
    // Given
    final store = givenState()
        .copyWith(
          loginState: LoginSuccessState(
            User(
              id: "user_id",
              firstName: "Kenji",
              lastName: "Dupont",
              loginMode: LoginMode.POLE_EMPLOI,
              email: "kenji.dupont@pe.fr",
              accompagnement: Accompagnement.cej,
            ),
          ),
        )
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.userEmail, "kenji.dupont@pe.fr");
    expect(viewModel.userName, "Kenji Dupont");
  });

  test("create when user email is null should display it properly", () {
    // Given
    final store = givenState()
        .copyWith(
          loginState: LoginSuccessState(
            User(
              id: "user_id",
              firstName: "Kenji",
              lastName: "Dupont",
              loginMode: LoginMode.POLE_EMPLOI,
              email: null,
              accompagnement: Accompagnement.cej,
            ),
          ),
        )
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.userEmail, "Non renseignée");
    expect(viewModel.userName, "Kenji Dupont");
  });

  test("create when developer options are not activated MUST NOT display them", () {
    // Given
    final store = givenState() //
        .loggedIn()
        .copyWith(developerOptionsState: DeveloperOptionsNotInitializedState())
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.displayDeveloperOptions, isFalse);
  });

  test("create when developer options are activated should display them", () {
    // Given
    final store = givenState() //
        .loggedIn()
        .copyWith(developerOptionsState: DeveloperOptionsActivatedState())
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.displayDeveloperOptions, isTrue);
  });

  test("create when user is from PE should display download CV card", () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.withDownloadCv, isTrue);
  });

  test("create when user is from Milo should not display download CV card", () {
    // Given
    final store = givenState() //
        .loggedInMiloUser()
        .store();

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.withDownloadCv, isFalse);
  });

  test('onTitleTap should trigger action', () {
    // Given
    final store = StoreSpy();
    final viewModel = ProfilPageViewModel.create(store);

    // When
    viewModel.onTitleTap();

    // Then
    expect(store.dispatchedAction, isA<DeveloperOptionsActivationRequestAction>());
  });

  group("mon conseiller should be", () {
    void assertMonConseillerIsDisplayed(bool isDisplayed, DetailsJeuneState state) {
      final verb = isDisplayed ? "displayed" : "hidden";
      test("$verb on ${state.runtimeType}", () {
        // Given
        final store = givenState().copyWith(detailsJeuneState: state).store();

        // When
        final viewModel = ProfilPageViewModel.create(store);

        // Then
        expect(viewModel.displayMonConseiller, isDisplayed);
      });
    }

    assertMonConseillerIsDisplayed(true, DetailsJeuneLoadingState());
    assertMonConseillerIsDisplayed(true, DetailsJeuneSuccessState(detailsJeune: detailsJeune()));
    assertMonConseillerIsDisplayed(true, DetailsJeuneFailureState());
    assertMonConseillerIsDisplayed(false, DetailsJeuneNotInitializedState());
  });
}
