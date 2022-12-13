import 'package:equatable/equatable.dart';

abstract class DeviceInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceInfoNotInitializedState extends DeviceInfoState {}

class DeviceInfoSuccessState extends DeviceInfoState {
  final String installationId;

  DeviceInfoSuccessState(this.installationId);

  @override
  List<Object?> get props => [installationId];
}
