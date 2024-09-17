import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/preferences/preferences_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/preferences/notification_preferences_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
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
    return StoreConnector<AppState, NotificationPreferencesViewModel>(
      onInit: (store) => store.dispatch(PreferencesRequestAction()),
      converter: (store) => NotificationPreferencesViewModel.create(store),
      builder: (context, viewModel) => _Body(viewModel),
      onDidChange: (previousViewModel, viewModel) => _onDidChange(previousViewModel, viewModel, context),
      distinct: true,
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
        title: "Gérer vos notifications", // TODO extract all strings
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Margins.spacing_base,
        vertical: Margins.spacing_m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recevoir des notifications pour les événements suivants :", style: TextStyles.textBaseRegular),
          SizedBox(height: Margins.spacing_base),
          _NotificationSwitch(
            title: "Alertes",
            description: "De nouvelles offres correspondent à vos alertes enregistrées",
            value: viewModel.withAlertesOffres,
            onChanged: viewModel.onAlertesOffresChanged,
          ),
          SizedBox(height: Margins.spacing_base),
          _NotificationSwitch(
            title: "Messagerie",
            description: "Réception d’un nouveau message",
            value: viewModel.withMessages,
            onChanged: viewModel.onMessagesChanged,
          ),
          SizedBox(height: Margins.spacing_base),
          _NotificationSwitch(
            title: "Mon suivi",
            description: "Création d’une action par votre conseiller",
            value: viewModel.withCreationAction,
            onChanged: viewModel.onCreationActionChanged,
          ),
          SizedBox(height: Margins.spacing_base),
          _NotificationSwitch(
            title: "Rendez-vous et sessions",
            description: "Inscription, modification ou suppression par votre conseiller",
            value: viewModel.withRendezvousSessions,
            onChanged: viewModel.onRendezvousSessionsChanged,
          ),
          SizedBox(height: Margins.spacing_base),
          _NotificationSwitch(
            title: "Rappels",
            description: "Rappel de complétion des actions (1 fois par semaine)",
            value: viewModel.withRappelActions,
            onChanged: viewModel.onRappelActionsChanged,
          ),
          SizedBox(height: Margins.spacing_l),
          Text("Paramètres système", style: TextStyles.textBaseBold),
          SizedBox(height: Margins.spacing_s),
          SizedBox(
            width: double.infinity,
            child: CardContainer(
              onTap: viewModel.onOpenAppSettings,
              child: Text(
                "↗ Ouvrir les paramètres de notifications",
                style: TextStyles.textSRegular(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSwitch extends StatelessWidget {
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.description,
    required this.value,
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
              label: Strings.partageFavorisEnabled(true),
              child: Switch(
                value: value,
                onChanged: (value) => onChanged(value),
              ),
            ),
            SizedBox(width: Margins.spacing_xs),
            Semantics(
              excludeSemantics: true,
              child: Text(
                value ? Strings.yes : Strings.no,
                style: TextStyles.textBaseRegularWithColor(AppColors.contentColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
