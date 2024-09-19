import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/notifications_settings/notifications_settings_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/features/preferences/preferences_state.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_actions.dart';
import 'package:pass_emploi_app/features/preferences/update/preferences_update_state.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class NotificationPreferencesViewModel extends Equatable {
  final DisplayState displayState;
  final bool withUpdateError;

  final bool withAlertesOffres;
  final bool withCreationAction;
  final bool withRendezvousSessions;
  final bool withRappelActions;
  final bool withMiloWording;

  final void Function(bool) onAlertesOffresChanged;
  final void Function(bool) onCreationActionChanged;
  final void Function(bool) onRendezvousSessionsChanged;
  final void Function(bool) onRappelActionsChanged;

  final void Function() onOpenAppSettings;
  final void Function() retry;

  NotificationPreferencesViewModel({
    required this.displayState,
    required this.withUpdateError,
    required this.withAlertesOffres,
    required this.withCreationAction,
    required this.withRendezvousSessions,
    required this.withRappelActions,
    required this.withMiloWording,
    required this.onAlertesOffresChanged,
    required this.onCreationActionChanged,
    required this.onRendezvousSessionsChanged,
    required this.onRappelActionsChanged,
    required this.onOpenAppSettings,
    required this.retry,
  });

  factory NotificationPreferencesViewModel.create(Store<AppState> store) {
    final state = store.state.preferencesState;
    final updateState = store.state.preferencesUpdateState;

    final Preferences? preferences = (state is PreferencesSuccessState) ? state.preferences : null;

    return NotificationPreferencesViewModel(
      displayState: _displayState(state),
      withUpdateError: updateState is PreferencesUpdateFailureState,
      withAlertesOffres: preferences?.pushNotificationAlertesOffres ?? false,
      withCreationAction: preferences?.pushNotificationCreationAction ?? false,
      withRendezvousSessions: preferences?.pushNotificationRendezvousSessions ?? false,
      withRappelActions: preferences?.pushNotificationRappelActions ?? false,
      withMiloWording: store.state.isMiloLoginMode(),
      onAlertesOffresChanged: (value) => store.dispatch(
        PreferencesUpdateRequestAction(pushNotificationAlertesOffres: value),
      ),
      onCreationActionChanged: (value) => store.dispatch(
        PreferencesUpdateRequestAction(pushNotificationCreationAction: value),
      ),
      onRendezvousSessionsChanged: (value) => store.dispatch(
        PreferencesUpdateRequestAction(pushNotificationRendezvousSessions: value),
      ),
      onRappelActionsChanged: (value) => store.dispatch(
        PreferencesUpdateRequestAction(pushNotificationRappelActions: value),
      ),
      onOpenAppSettings: () => store.dispatch(NotificationsSettingsRequestAction()),
      retry: () => store.dispatch(PreferencesRequestAction()),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
        withUpdateError,
        withAlertesOffres,
        withCreationAction,
        withRendezvousSessions,
        withRappelActions,
        withMiloWording,
      ];
}

DisplayState _displayState(PreferencesState preferencesState) => switch (preferencesState) {
      PreferencesSuccessState() => DisplayState.CONTENT,
      PreferencesFailureState() => DisplayState.FAILURE,
      _ => DisplayState.LOADING,
    };
