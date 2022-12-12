import 'package:pass_emploi_app/features/device_info/device_info_actions.dart';
import 'package:pass_emploi_app/features/device_info/device_info_state.dart';

DeviceInfoState deviceInfoReducer(DeviceInfoState current, dynamic action) {
  if (action is DeviceInfoSuccessAction) return DeviceInfoSuccessState(action.uuid);
  return current;
}
