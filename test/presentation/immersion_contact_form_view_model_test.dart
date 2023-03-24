import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/immersion_contact_form_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';
import '../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  test('test should create a form with user email, first name and last name', () {
    // Given
    sut.givenStore = givenState()
        .copyWith(
            loginState: successMiloUserState(
                user: mockedMiloUser().copyWith(
          email: "some.user@example.com",
          firstName: "John",
          lastName: "Doe",
        )))
        .store();

    // When
    final viewModel = ImmersionContactFormViewModel.create(sut.givenStore);

    // Then
    expect(viewModel.userEmailInitialValue, "some.user@example.com");
    expect(viewModel.userFirstNameInitialValue, "John");
    expect(viewModel.userLastNameInitialValue, "Doe");
  });
}
