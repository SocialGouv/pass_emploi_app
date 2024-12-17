import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_actions.dart';
import 'package:pass_emploi_app/features/in_app_notifications/in_app_notifications_state.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/in_app_notification.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class NotificationsCenterViewModel extends Equatable {
  NotificationsCenterViewModel({
    required this.notifications,
    required this.displayState,
    required this.retry,
  });

  final DisplayState displayState;
  final List<NotificationViewModel> notifications;
  final void Function() retry;

  factory NotificationsCenterViewModel.create(Store<AppState> store) {
    final inAppNotificationsState = store.state.inAppNotificationsState;
    return NotificationsCenterViewModel(
      displayState: _displayState(inAppNotificationsState),
      notifications: _notifications(inAppNotificationsState, store),
      retry: () => store.dispatch(InAppNotificationsRequestAction()),
    );
  }

  @override
  List<Object?> get props => [];
}

DisplayState _displayState(InAppNotificationsState inAppNotificationsState) {
  return switch (inAppNotificationsState) {
    InAppNotificationsNotInitializedState() => DisplayState.LOADING,
    InAppNotificationsLoadingState() => DisplayState.LOADING,
    InAppNotificationsFailureState() => DisplayState.FAILURE,
    final InAppNotificationsSuccessState state =>
      state.notifications.isEmpty ? DisplayState.EMPTY : DisplayState.CONTENT,
  };
}

List<NotificationViewModel> _notifications(
  InAppNotificationsState inAppNotificationsState,
  Store<AppState> store,
) {
  if (inAppNotificationsState is! InAppNotificationsSuccessState) {
    return [];
  }

  return inAppNotificationsState.notifications
      .map((notification) => NotificationViewModel(
            title: notification.titre,
            description: notification.description,
            date: notification.date.toDayWithFullMonthContextualized(),
            onPressed: switch (notification.type) {
              InAppNotificationType.newRendezvous || //
              InAppNotificationType.updatedRendezvous =>
                () => store.dispatch(
                      HandleDeepLinkAction(RendezvousDeepLink(notification.idObjet!), DeepLinkOrigin.inAppNavigation),
                    ),
              _ => null
            },
          ))
      .toList();
}

class NotificationViewModel extends Equatable {
  NotificationViewModel({
    required this.title,
    required this.description,
    required this.date,
    this.onPressed,
  });

  final String title;
  final String description;
  final String date;
  final void Function()? onPressed;

  @override
  List<Object?> get props => [title, description, date];
}
