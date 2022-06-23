import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/features/configuration/configuration_state.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_action.dart';
import 'package:pass_emploi_app/features/developer_option/activation/developer_options_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('DeveloperOptionsActivationRequestAction should activate developer options on STAGING flavor', () async {
    // Given
    final store = givenState() //
        .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.STAGING))) //
        .store();

    // When
    await store.dispatch(DeveloperOptionsActivationRequestAction());

    // Then
    expect(store.state.developerOptionsState, isA<DeveloperOptionsActivatedState>());
  });

  test('DeveloperOptionsActivationRequestAction MUST NOT activate developer options on PROD flavor', () async {
    // Given
    final store = givenState() //
        .copyWith(configurationState: ConfigurationState(configuration(flavor: Flavor.PROD))) //
        .store();

    // When
    await store.dispatch(DeveloperOptionsActivationRequestAction());

    // Then
    expect(store.state.developerOptionsState, isA<DeveloperOptionsNotInitializedState>());
  });
}
