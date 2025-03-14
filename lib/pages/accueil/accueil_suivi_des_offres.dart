import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilSuiviDesOffres extends StatelessWidget {
  final AccueilSuiviDesOffresItem item;

  AccueilSuiviDesOffres(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilOffresEnregistreesSection),
        SizedBox(height: Margins.spacing_base),
        _Illustration(),
      ],
    );
  }
}

class _Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onLongPress: () => _goToOffresEnregistrees(context),
      child: Row(
        children: [
          Image.asset(
            "assets/illustrations/accueil_offres_suivies.webp",
            width: 70,
            height: 70,
          ),
          SizedBox(width: Margins.spacing_base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(Strings.suivezVosOffres, style: TextStyles.textSBold),
                Text(Strings.suivezVosOffresDescription, style: TextStyles.textSRegular()),
              ],
            ),
          ),
          Icon(AppIcons.chevron_right_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  void _goToOffresEnregistrees(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        OffresEnregistreesDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }
}
