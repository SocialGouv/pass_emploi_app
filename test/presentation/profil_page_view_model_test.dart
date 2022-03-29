import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/conseiller/conseiller_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/presentation/profil/profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

void main() {
  test("create should properly set user info", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginSuccessState(
          User(
            id: "user_id",
            firstName: "Kenji",
            lastName: "Dupont",
            loginMode: LoginMode.POLE_EMPLOI,
            email: "kenji.dupont@pe.fr",
          ),
        ),
      ),
    );

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.userEmail, "kenji.dupont@pe.fr");
    expect(viewModel.userName, "Kenji Dupont");
  });

  test("create when user email is null should display it properly", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        loginState: LoginSuccessState(
          User(
            id: "user_id",
            firstName: "Kenji",
            lastName: "Dupont",
            loginMode: LoginMode.POLE_EMPLOI,
            email: null,
          ),
        ),
      ),
    );

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.userEmail, "Non renseignée");
    expect(viewModel.userName, "Kenji Dupont");
  });

  test("should display mon conseiller", () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        conseillerState: ConseillerSuccessState(conseillerInfo: monConseillerInfoPerceval()),
      ),
    );

    // When
    final viewModel = ProfilPageViewModel.create(store);

    // Then
    expect(viewModel.displayMonConseiller, true);
  });
}
