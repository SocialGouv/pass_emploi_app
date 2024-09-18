import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/preferences/notification_preferences_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class NotificationPreferencesPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => NotificationPreferencesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.notificationPreferences,
      child: StoreConnector<AppState, NotificationPreferencesViewModel>(
        onInit: (store) => store.dispatch(PreferencesRequestAction()),
        converter: (store) => NotificationPreferencesViewModel.create(store),
        builder: (context, viewModel) => _Body(viewModel),
        onDidChange: (previousViewModel, viewModel) => _onDidChange(previousViewModel, viewModel, context),
        distinct: true,
      ),
    );
  }

  void _onDidChange(
    NotificationPreferencesViewModel? previousViewModel,
    NotificationPreferencesViewModel viewModel,
    BuildContext context,
  ) {
    if (previousViewModel?.withUpdateError != viewModel.withUpdateError && viewModel.withUpdateError) {
      showSnackBarWithSystemError(context);
    }
  }
}

class _Body extends StatelessWidget {
  final NotificationPreferencesViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(
        title: Strings.notificationsSettingsAppbarTitle,
        withProfileButton: false,
        canPop: true,
      ),
      body: switch (viewModel.displayState) {
        DisplayState.CONTENT => _Content(viewModel),
        DisplayState.FAILURE => Retry(Strings.miscellaneousErrorRetry, () => viewModel.retry()),
        _ => Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel);

  final NotificationPreferencesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: Margins.spacing_base,
          vertical: Margins.spacing_m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.notificationsSettingsSubtitle, style: TextStyles.textBaseRegular),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: Strings.notificationsSettingsAlertesTitle,
              description: Strings.notificationsSettingsAlertesSubtitle,
              enabled: viewModel.withAlertesOffres,
              onChanged: viewModel.onAlertesOffresChanged,
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: Strings.notificationsSettingsMessagerieTitle,
              description: Strings.notificationsSettingsMessagerieSubtitle,
              enabled: viewModel.withMessages,
              onChanged: viewModel.onMessagesChanged,
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: Strings.notificationsSettingsMonSuiviTitle,
              description: Strings.notificationsSettingsMonSuiviSubtitle(viewModel.withMiloWording),
              enabled: viewModel.withCreationAction,
              onChanged: viewModel.onCreationActionChanged,
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: Strings.notificationsSettingsRendezVoussTitle(viewModel.withMiloWording),
              description: Strings.notificationsSettingsRendezVousSubtitle,
              enabled: viewModel.withRendezvousSessions,
              onChanged: viewModel.onRendezvousSessionsChanged,
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: Strings.notificationsSettingsRappelsTitle,
              description: Strings.notificationsSettingsRappelsSubtitle,
              enabled: viewModel.withRappelActions,
              onChanged: viewModel.onRappelActionsChanged,
            ),
            SizedBox(height: Margins.spacing_l),
            Text(Strings.notificationsSettingsTitle, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_s),
            SizedBox(
              width: double.infinity,
              child: CardContainer(
                onTap: viewModel.onOpenAppSettings,
                child: Row(
                  children: [
                    Icon(AppIcons.open_in_new_rounded, color: AppColors.contentColor),
                    SizedBox(width: Margins.spacing_base),
                    Expanded(
                      child: Text(
                        Strings.openNotificationsSettings,
                        style: TextStyles.textSRegular(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String title;
  final String description;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.description,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Semantics(
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Margins.spacing_s),
                Text(
                  title,
                  style: TextStyles.textBaseBold,
                ),
                SizedBox(height: Margins.spacing_s),
                Text(
                  description,
                  style: TextStyles.textSRegular(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: Margins.spacing_m),
        Row(
          children: [
            Semantics(
              label: enabled
                  ? Strings.notificationsA11yDisable + description
                  : Strings.notificationsA11yEnable + description,
              child: Switch(
                value: enabled,
                onChanged: (value) => onChanged(value),
              ),
            ),
            SizedBox(width: Margins.spacing_xs),
            Semantics(
              excludeSemantics: true,
              child: Text(
                enabled ? Strings.yes : Strings.no,
                style: TextStyles.textBaseRegularWithColor(AppColors.contentColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
