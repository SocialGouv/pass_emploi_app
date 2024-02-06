import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/device_info/device_info_state.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('DeviceInfo', () {
    final sut = StoreSut();

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should set installation id', () {
        sut.givenStore = givenState() //
            .store((f) => {f.installationIdRepository = FakeInstallationIdRepository()});

        sut.thenExpectChangingStatesThroughOrder([_shouldSetUuid()]);
      });
    });
  });
}

Matcher _shouldSetUuid() {
  return StateIs<DeviceInfoSuccessState>(
    (state) => state.deviceInfoState,
    (state) {
      expect(state.installationId, "super-unique-id");
    },
  );
}

class FakeInstallationIdRepository extends InstallationIdRepository {
  FakeInstallationIdRepository() : super(MockFlutterSecureStorage());

  @override
  Future<String> getInstallationId() async {
    return "super-unique-id";
  }
}
