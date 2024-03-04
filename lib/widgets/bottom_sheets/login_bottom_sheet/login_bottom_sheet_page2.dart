import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/presentation/login_bottom_sheet_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

class LoginBottomSheetPage2 extends StatelessWidget {
  const LoginBottomSheetPage2({super.key, required this.viewModel});
  final LoginButtonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final isPoleEmploi = viewModel.isPoleEmploi;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Margins.spacing_s),
        _AppBarTitle(),
        SizedBox(height: Margins.spacing_m),
        _HighlightInformations(
          icon: AppIcons.account_circle_rounded,
          boldText: Strings.loginInfosUserName(isPoleEmploi)[0],
          text: Strings.loginInfosUserName(isPoleEmploi)[1],
        ),
        SizedBox(height: Margins.spacing_base),
        _HighlightInformations(
          icon: AppIcons.lock_rounded,
          boldText: Strings.loginBottomSheetPasswordInfos(isPoleEmploi)[0],
          text: Strings.loginBottomSheetPasswordInfos(isPoleEmploi)[1],
        ),
        SizedBox(height: Margins.spacing_base),
        _RecuperationInfos(isPoleEmploi: isPoleEmploi),
        SizedBox(height: Margins.spacing_m),
        PrimaryActionButton(
          label: Strings.loginAction,
          onPressed: () {
            Navigator.pop(context);
            viewModel.action();
          },
        ),
        SizedBox(height: Margins.spacing_s),
        _OpenInNewDescription(isPoleEmploi: isPoleEmploi),
        SizedBox(height: Margins.spacing_m),
        _NoAccount(),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(
          label: Strings.askAccount,
          onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
        )
      ],
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(Strings.loginBottomSeetTitlePage2, style: TextStyles.textMBold),
    );
  }
}

class _HighlightInformations extends StatelessWidget {
  const _HighlightInformations({required this.icon, required this.boldText, required this.text});
  final IconData icon;
  final String boldText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: Margins.spacing_s),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyles.textBaseRegular,
              children: [
                TextSpan(text: boldText, style: TextStyles.textBaseBold),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecuperationInfos extends StatelessWidget {
  final bool isPoleEmploi;

  const _RecuperationInfos({required this.isPoleEmploi});

  @override
  Widget build(BuildContext context) {
    return Text(Strings.loginBottomSheetRecuperationInfos(isPoleEmploi), style: TextStyles.textBaseRegular);
  }
}

class _OpenInNewDescription extends StatelessWidget {
  final bool isPoleEmploi;

  const _OpenInNewDescription({required this.isPoleEmploi});

  @override
  Widget build(BuildContext context) {
    return Text(
      Strings.loginOpenInNewDescription(isPoleEmploi),
      textAlign: TextAlign.center,
      style: TextStyles.textSMedium(),
    );
  }
}

class _NoAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(Strings.loginNoAccount, style: TextStyles.textBaseRegular);
  }
}
