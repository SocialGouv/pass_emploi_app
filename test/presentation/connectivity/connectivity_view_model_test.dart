import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/connectivity/connectivity_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('connectivity result should properly update display', () {
    void assertConnectivity(ConnectivityResult result, bool expectedIsConnected) {
      test("ConnectivityResult: $result > expectedIsConnected: $expectedIsConnected", () {
        // Given
        final store = givenState().withConnectivity(result).store();

        // When
        final viewModel = ConnectivityViewModel.create(store);

        // Then
        expect(viewModel.isConnected, expectedIsConnected);
      });
    }

    for (var result in ConnectivityResult.values) {
      final bool expectedIsConnected = result != ConnectivityResult.none;
      assertConnectivity(result, expectedIsConnected);
    }
  });
}
