import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/configuration/configuration_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('on STAGING flavor', () {
    test('DeveloperOptionsActivationRequestAction should activate developer options', () {
      // Given
      final store = givenState() //
          .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.STAGING)))
          .store();

      // When
      store.dispatch(DeveloperOptionsActivationRequestAction());

      // Then
      expect(store.state.developerOptionsState, isA<DeveloperOptionsActivatedState>());
    });

    test('DeveloperOptionsDeleteAllPrefsAction should call repository', () {
      // Given
      final repository = MockDeveloperOptionRepository();
      when(() => repository.deleteAllPrefs()).thenAnswer((_) async {});
      final store = givenState() //
          .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.STAGING)))
          .store((f) => {f.developerOptionRepository = repository});

      // When
      store.dispatch(DeveloperOptionsDeleteAllPrefsAction());

      // Then
      verify(() => repository.deleteAllPrefs()).called(1);
    });
  });

  group('on PROD flavor', () {
    test('DeveloperOptionsActivationRequestAction MUST NOT activate developer options', () {
      // Given
      final store = givenState() //
          .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.PROD)))
          .store();

      // When
      store.dispatch(DeveloperOptionsActivationRequestAction());

      // Then
      expect(store.state.developerOptionsState, isA<DeveloperOptionsNotInitializedState>());
    });

    test('DeveloperOptionsDeleteAllPrefsAction MUST NOT call repository', () {
      // Given
      final repository = MockDeveloperOptionRepository();
      final store = givenState() //
          .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.PROD)))
          .store((f) => {f.developerOptionRepository = repository});

      // When
      store.dispatch(DeveloperOptionsDeleteAllPrefsAction());

      // Then
      verifyNever(() => repository.deleteAllPrefs());
    });
  });
}
