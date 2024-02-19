import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilCetteSemaine extends StatelessWidget {
  final AccueilCetteSemaineItem item;

  AccueilCetteSemaine(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilCetteSemaineSection),
        SizedBox(height: Margins.spacing_base),
        CardContainer(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _BlocInfo(
                        icon: AppIcons.event,
                        label: Strings.accueilRendezvous,
                        count: item.rendezvousCount,
                        backgroundColor: AppColors.accent1Lighten,
                        contentColor: AppColors.additional3,
                      ),
                    ),
                    SizedBox(width: Margins.spacing_base),
                    Expanded(
                      child: _BlocInfo(
                        icon: AppIcons.bolt_outlined,
                        label: item.actionsOuDemarchesLabel,
                        count: item.actionsOuDemarchesCount,
                        backgroundColor: AppColors.primaryLighten,
                        contentColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_base),
                SecondaryButton(
                  label: Strings.accueilVoirDetailsCetteSemaine,
                  onPressed: () => StoreProvider.of<AppState>(context).dispatch(
                    HandleDeepLinkAction(
                      AgendaDeepLink(),
                      DeepLinkOrigin.inAppNavigation,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    return DecoratedBox(
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
    );
  }
}
