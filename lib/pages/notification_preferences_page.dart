import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/notifications_settings/notifications_settings_actions.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class NotificationPreferencesPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => NotificationPreferencesPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: PrimaryAppBar(
        title: "Gérer vos notifications", // TODO extract all strings
        withProfileButton: false,
        canPop: true,
      ),
      body: SingleChildScrollView(
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
              initialValue: true,
              onChanged: (value) => print("Alertes: $value"),
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: "Messagerie",
              description: "Réception d’un nouveau message",
              initialValue: true,
              onChanged: (value) => print("Chat: $value"),
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: "Mon suivi",
              description: "Création d’une action par votre conseiller",
              initialValue: true,
              onChanged: (value) => print("Mon suivi: $value"),
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: "Rendez-vous et sessions",
              description: "Inscription, modification ou suppression par votre conseiller",
              initialValue: true,
              onChanged: (value) => print("Rendez-vous et sessions: $value"),
            ),
            SizedBox(height: Margins.spacing_base),
            _NotificationSwitch(
              title: "Rappels",
              description: "Rappel de complétion des actions (1 fois par semaine)",
              initialValue: true,
              onChanged: (value) => print("Rappels: $value"),
            ),
            SizedBox(height: Margins.spacing_l),
            Text("Paramètres système", style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_s),
            SizedBox(
              width: double.infinity,
              child: CardContainer(
                child: Text("↗ Ouvrir les paramètres de notifications", style: TextStyles.textSRegular()),
                onTap: () => context.dispatch(NotificationsSettingsRequestAction()), //TODO move to view model
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSwitch extends StatefulWidget {
  final String title;
  final String description;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitch({
    required this.title,
    required this.description,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<_NotificationSwitch> {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

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
                  widget.title,
                  style: TextStyles.textBaseBold,
                ),
                SizedBox(height: Margins.spacing_s),
                Text(
                  widget.description,
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
                value: _value,
                onChanged: (value) {
                  setState(() => _value = value);
                  widget.onChanged(value);
                },
              ),
            ),
            SizedBox(width: Margins.spacing_xs),
            Semantics(
              excludeSemantics: true,
              child: Text(
                _value ? Strings.yes : Strings.no,
                style: TextStyles.textBaseRegularWithColor(AppColors.contentColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
