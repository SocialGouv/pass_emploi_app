import 'package:equatable/equatable.dart';

abstract class DeviceInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceInfoNotInitializedState extends DeviceInfoState {}

class DeviceInfoSuccessState extends DeviceInfoState {
  final String uuid;

  DeviceInfoSuccessState(this.uuid);

  @override
  List<Object?> get props => [uuid];
}
