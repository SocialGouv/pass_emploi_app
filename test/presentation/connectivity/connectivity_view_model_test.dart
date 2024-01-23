import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/connectivity/connectivity_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('connectivity result should properly update display', () {
    void assertConnectivity(ConnectivityResult result, bool expectedIsOnline) {
      test("ConnectivityResult: $result > expectedIsOnline: $expectedIsOnline", () {
        // Given
        final store = givenState().withConnectivity(result).store();

        // When
        final viewModel = ConnectivityViewModel.create(store);

        // Then
        expect(viewModel.isOnline, expectedIsOnline);
      });
    }

    for (var result in ConnectivityResult.values) {
      final bool expectedIsOnline = result != ConnectivityResult.none;
      assertConnectivity(result, expectedIsOnline);
    }
  });

  test('when mode demo is activated, always return isOnline to true to hide header', () {
    // Given
    final store = givenState() //
        .copyWith(demoState: true)
        .withConnectivity(ConnectivityResult.none)
        .store();

    // When
    final viewModel = ConnectivityViewModel.create(store);

    // Then
    expect(viewModel.isOnline, isTrue);
  });
}
