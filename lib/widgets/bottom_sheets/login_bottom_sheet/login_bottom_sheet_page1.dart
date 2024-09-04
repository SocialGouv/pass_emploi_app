import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/login_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/external_links.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/elevated_button_tile.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';

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
        InfoCard(message: Strings.organismInformations),
        SizedBox(height: Margins.spacing_base),
        ..._buildLoginButtons(),
        _NoOrganismButton(),
        SizedBox(height: Margins.spacing_base),
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
    };
  }
}

class _NoOrganismButton extends StatelessWidget {
  static const noOrganismeLink = ExternalLinks.unJeuneUneSolution;

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTile(
      onPressed: () {
        PassEmploiMatomoTracker.instance.trackOutlink(noOrganismeLink);
        launchExternalUrl(noOrganismeLink);
      },
      label: Strings.loginBottomSeetNoOrganism,
      leading: Semantics(
        child: Icon(AppIcons.open_in_new_rounded),
      ),
      suffix: Semantics(label: Strings.link),
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
