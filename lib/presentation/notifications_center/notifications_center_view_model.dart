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
    return NotificationsCenterViewModel(
      displayState: _displayState(store.state.inAppNotificationsState),
      notifications: _notifications(store),
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

List<NotificationViewModel> _notifications(Store<AppState> store) {
  final inAppNotificationsState = store.state.inAppNotificationsState;
  final dateDerniereConsultation = store.state.dateConsultationNotificationState.date;
  if (inAppNotificationsState is! InAppNotificationsSuccessState) {
    return [];
  }

  return inAppNotificationsState.notifications.map((notification) {
    final deepLink = _fromInAppNotification(notification.type, notification.idObjet);
    return NotificationViewModel(
      isNew: dateDerniereConsultation != null ? notification.date.isAfter(dateDerniereConsultation) : false,
      title: notification.titre,
      description: notification.description,
      date: notification.date.toDayWithFullMonthContextualized(),
      onPressed: deepLink != null
          ? () => store.dispatch(
                HandleDeepLinkAction(
                  deepLink,
                  DeepLinkOrigin.inAppNavigation,
                ),
              )
          : null,
    );
  }).toList();
}

DeepLink? _fromInAppNotification(InAppNotificationType type, String? idObjet) {
  return switch (type) {
    InAppNotificationType.newAction => idObjet != null ? ActionDeepLink(idObjet) : null,
    InAppNotificationType.detailAction => idObjet != null ? ActionDeepLink(idObjet) : null,
    InAppNotificationType.rappelRendezvous => idObjet != null ? RendezvousDeepLink(idObjet) : null,
    InAppNotificationType.newRendezvous => idObjet != null ? RendezvousDeepLink(idObjet) : null,
    InAppNotificationType.updatedRendezvous => idObjet != null ? RendezvousDeepLink(idObjet) : null,
    InAppNotificationType.nouvelleOffre => AlertesDeepLink(),
    InAppNotificationType.detailSessionMilo => idObjet != null ? SessionMiloDeepLink(idObjet) : null,
    InAppNotificationType.rappelCreationAction => RappelCreationActionDeepLink(),
    InAppNotificationType.rappelCreationDemarche => RappelCreationDemarcheDeepLink(),
    InAppNotificationType.deletedSessionMilo => null,
    InAppNotificationType.deletedRendezvous => null,
    InAppNotificationType.unknown => null,
  };
}

class NotificationViewModel extends Equatable {
  NotificationViewModel({
    required this.isNew,
    required this.title,
    required this.description,
    required this.date,
    this.onPressed,
  });

  final bool isNew;
  final String title;
  final String description;
  final String date;
  final void Function()? onPressed;

  @override
  List<Object?> get props => [title, description, date, isNew];
}
