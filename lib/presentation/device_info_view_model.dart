import 'package:pass_emploi_app/features/device_info/device_info_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DeviceInfoViewModel {
  final String installationId;

  DeviceInfoViewModel({required this.installationId});

  factory DeviceInfoViewModel.fromStore(Store<AppState> store) {
    final state = store.state.deviceInfoState;
    if (state is DeviceInfoSuccessState) {
      return DeviceInfoViewModel(installationId: state.installationId);
    }
    return DeviceInfoViewModel(installationId: "");
  }
}