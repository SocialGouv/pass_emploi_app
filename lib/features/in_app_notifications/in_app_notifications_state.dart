import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/in_app_notification.dart';

sealed class InAppNotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InAppNotificationsNotInitializedState extends InAppNotificationsState {}

class InAppNotificationsLoadingState extends InAppNotificationsState {}

class InAppNotificationsFailureState extends InAppNotificationsState {}

class InAppNotificationsSuccessState extends InAppNotificationsState {
  final List<InAppNotification> result;

  InAppNotificationsSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
