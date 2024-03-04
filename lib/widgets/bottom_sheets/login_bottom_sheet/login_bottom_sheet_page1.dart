import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/login_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/elevated_button_tile.dart';

class LoginBottomSheetPage1 extends StatelessWidget {
  const LoginBottomSheetPage1({required this.loginButtons, required this.onLoginButtonSelected});
  final List<LoginButtonViewModel> loginButtons;
  final void Function(LoginButtonViewModel) onLoginButtonSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Margins.spacing_s),
        _AppBarTitle(),
        SizedBox(height: Margins.spacing_m),
        _OrganismInformations(),
        SizedBox(height: Margins.spacing_base),
        ..._buildLoginButtons(),
        _NoOrganismButton(),
      ],
    );
  }

  List<Widget> _buildLoginButtons() {
    final buttons = loginButtons.map((button) => _loginButton(button)).toList();
    return buttons.expand((element) => [element, SizedBox(height: Margins.spacing_base)]).toList();
  }

  Widget _loginButton(LoginButtonViewModel button) {
    void onSelected() => onLoginButtonSelected(button);
    return switch (button) {
      LoginButtonViewModelPoleEmploi() => _FranceTravailLoginButton(onSelected: onSelected),
      LoginButtonViewModelMissionLocale() => _MissionLocaleLoginButton(onSelected: onSelected),
      LoginButtonViewModelPassEmploi() => _PassEmploiLoginButton(onSelected: onSelected),
    };
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
      suffix: Semantics(
        label: Strings.openInNewTab,
        child: Icon(AppIcons.open_in_new_rounded),
      ),
    );
  }
}

class _MissionLocaleLoginButton extends StatelessWidget {
  const _MissionLocaleLoginButton({required this.onSelected});
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(Drawables.missionLocaleLogo),
      ),
      onPressed: onSelected,
      label: Strings.loginBottomSeetMissionLocaleButton,
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}

class _PassEmploiLoginButton extends StatelessWidget {
  const _PassEmploiLoginButton({required this.onSelected});
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(
          Drawables.passEmploiLogo,
          fit: BoxFit.cover,
        ),
      ),
      onPressed: onSelected,
      label: Strings.loginBottomSeetPassEmploiButton,
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}

class _FranceTravailLoginButton extends StatelessWidget {
  const _FranceTravailLoginButton({required this.onSelected});
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: Image.asset(Drawables.poleEmploiLogo),
      ),
      onPressed: onSelected,
      label: Strings.loginBottomSeetFranceTravailButton,
      suffix: Icon(AppIcons.chevron_right_rounded),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(Strings.loginBottomSeetTitlePage1, style: TextStyles.textMBold),
    );
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
