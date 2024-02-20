import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/elevated_button_tile.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const LoginBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: "",
      body: Column(
        children: [
          SizedBox(height: Margins.spacing_s),
          _AppBarTitle(),
          SizedBox(height: Margins.spacing_m),
          _OrganismInformations(),
          SizedBox(height: Margins.spacing_base),
          _FranceTravailLoginButton(),
          SizedBox(height: Margins.spacing_base),
          _MissionLocaleLoginButton(),
          SizedBox(height: Margins.spacing_base),
          _NoOrganismButton(),
        ],
      ),
    );
  }
}

class _NoOrganismButton extends StatelessWidget {
  static const noOrganismeLink = "https://www.1jeune1solution.gouv.fr/contrat-engagement-jeune";

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      onPressed: () {
        PassEmploiMatomoTracker.instance.trackOutlink(noOrganismeLink);
        launchExternalUrl(noOrganismeLink);
      },
      label: Strings.loginBottomSeetNoOrganism,
      suffix: Icon(AppIcons.open_in_new_rounded),
    );
  }
}

class _MissionLocaleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset("assets/logo-mission-locale.webp"),
      ),
      onPressed: () {},
      label: Strings.loginBottomSeetMissionLocaleButton,
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}

class _FranceTravailLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset("assets/logo-france-travail.webp"),
      ),
      onPressed: () {},
      label: Strings.loginBottomSeetFranceTravailButton,
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(Strings.loginBottomSeetTitlePage1, style: TextStyles.textMBold);
  }
}

class _OrganismInformations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs),
          child: Icon(AppIcons.info_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: Margins.spacing_s),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyles.textBaseRegular,
              children: [
                TextSpan(text: Strings.organismInformations[0]),
                TextSpan(text: Strings.organismInformations[1], style: TextStyles.textBaseBold),
                TextSpan(text: Strings.organismInformations[2]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
