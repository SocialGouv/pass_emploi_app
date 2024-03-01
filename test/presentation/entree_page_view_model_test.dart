import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/presentation/entree_page_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('EntreePageViewModel', () {
    test('entree page view model should not display demander un compte when brand is BRSA', () {
      // Given
      final store = givenBrsaState().agenda().store();

      // When
      final viewModel = EntreePageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, false);
    });

    test('entree page view model should display demander un compte when brand is CEJ', () {
      // Given
      final store = givenState().agenda().store();

      // When
      final viewModel = EntreePageViewModel.create(store);

      // Then
      expect(viewModel.withRequestAccountButton, true);
    });

    test('View model displays loading when login state is loading', () {
      final store = givenState().copyWith(loginState: LoginLoadingState()).store();

      final viewModel = EntreePageViewModel.create(store);

      expect(viewModel.withLoading, isTrue);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays error message when login state is generic failure', () {
      final store = givenState().copyWith(loginState: LoginGenericFailureState('error-message')).store();

      final viewModel = EntreePageViewModel.create(store);

      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, 'error-message');
    });

    test('View model displays specific message when login state is wrong device clock failure', () {
      final store = givenState().copyWith(loginState: LoginWrongDeviceClockState()).store();

      final viewModel = EntreePageViewModel.create(store);

      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isTrue);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays content when login state is not logged in', () {
      final store = givenState().copyWith(loginState: UserNotLoggedInState()).store();

      final viewModel = EntreePageViewModel.create(store);

      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });

    test('View model displays content when login state is logged in', () {
      final store = givenState().loggedInUser().store();

      final viewModel = EntreePageViewModel.create(store);

      expect(viewModel.withLoading, isFalse);
      expect(viewModel.withWrongDeviceClockMessage, isFalse);
      expect(viewModel.technicalErrorMessage, isNull);
    });
  });
}
