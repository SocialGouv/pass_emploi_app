import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_comptage_des_heures.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilCetteSemaine extends StatelessWidget {
  final AccueilCetteSemaineItem item;

  AccueilCetteSemaine(this.item);

  @override
  Widget build(BuildContext context) {
    final rendezvousCount = item.rendezvousCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilCetteSemaineSection, color: Colors.white),
        SizedBox(height: Margins.spacing_base),
        if (item.withComptageDesHeures || 1 == 1) ...[
          // TODO: REMOVE THIS
          AccueilComptageDesHeures(),
          SizedBox(height: Margins.spacing_base),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (rendezvousCount != null) ...[
                  Expanded(
                    child: _BlocInfo(
                      icon: AppIcons.event,
                      label: Strings.accueilRendezvous,
                      count: rendezvousCount,
                      backgroundColor: Colors.white,
                      contentColor: AppColors.contentColor,
                    ),
                  ),
                  SizedBox(width: Margins.spacing_base),
                ],
                Expanded(
                  child: _BlocInfo(
                    icon: AppIcons.bolt_outlined,
                    label: item.actionsOuDemarchesLabel,
                    count: item.actionsOuDemarchesCount,
                    backgroundColor: Colors.white,
                    contentColor: AppColors.contentColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: Margins.spacing_base),
            SecondaryButton(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              label: Strings.accueilVoirDetailsCetteSemaine,
              onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                HandleDeepLinkAction(
                  MonSuiviDeepLink(),
                  DeepLinkOrigin.inAppNavigation,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BlocInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final Color backgroundColor;
  final Color contentColor;

  const _BlocInfo({
    required this.icon,
    required this.label,
    required this.count,
    required this.backgroundColor,
    required this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Dimens.radius_base),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: contentColor, size: Dimens.icon_size_m),
                  SizedBox(width: Margins.spacing_s),
                  Text(count, style: TextStyles.textMBold.copyWith(color: contentColor)),
                ],
              ),
              SizedBox(height: Margins.spacing_xs),
              Text(label, style: TextStyles.textXsBold(color: contentColor)),
            ],
          ),
        ),
      ),
    );
  }
}
