import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/profil_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/profil_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/label_value_row.dart';

class ProfilPage extends TraceableStatelessWidget {
  static const legalNoticeLink = "https://beta.gouv.fr/startups/pass-emploi.html";
  static const privacyPolicyLink = "https://beta.gouv.fr/startups/pass-emploi.html";

  ProfilPage() : super(name: AnalyticsScreenNames.plus);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProfilPageViewModel>(
      converter: (store) => ProfilPageViewModel.create(store),
      builder: (BuildContext context, ProfilPageViewModel vm) => _buildScaffold(context, vm),
      distinct: true,
    );
  }

  Scaffold _buildScaffold(BuildContext context, ProfilPageViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: passEmploiAppBar(label: Strings.menuProfil),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(viewModel.userName, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              ProfilCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(Strings.personalInformation, style: TextStyles.textMBold),
                    SizedBox(height: Margins.spacing_m),
                    LabelValueRow(
                      label: Text(Strings.emailAddressLabel, style: TextStyles.textBaseRegular),
                      value: Text(
                        viewModel.userEmail,
                        style: TextStyles.textBaseBold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Margins.spacing_m),
              Text(Strings.legalInformation, style: TextStyles.textLBold()),
              SizedBox(height: Margins.spacing_m),
              ProfilCard(
                padding: EdgeInsets.zero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () => launch(legalNoticeLink),
                          child: Padding(
                            padding: const EdgeInsets.all(Margins.spacing_base),
                            child: LabelValueRow(
                              label: Text(Strings.legalNoticeLabel, style: TextStyles.textBaseRegular),
                              value: _redirectIcon(),
                            ),
                          ),
                        ),
                        SepLine(0, 0, color: AppColors.grey100),
                        InkWell(
                          onTap: () => launch(privacyPolicyLink),
                          child: Padding(
                            padding: const EdgeInsets.all(Margins.spacing_base),
                            child: LabelValueRow(
                              label: Text(Strings.privacyPolicyLabel, style: TextStyles.textBaseRegular),
                              value: _redirectIcon(),
                            ),
                          ),
                        ),
                        SepLine(0, 0, color: AppColors.grey100),
                        Padding(
                          padding: const EdgeInsets.all(Margins.spacing_base),
                          child: LabelValueRow(
                            label: Text(Strings.accessibilityLevelLabel, style: TextStyles.textBaseRegular),
                            value: Text(
                              Strings.accessibilityLevelNonConforme,
                              style: TextStyles.textBaseBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Margins.spacing_m),
              SecondaryButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(RequestLogoutAction(LogoutRequester.USER));
                },
                label: Strings.logoutAction,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SvgPicture _redirectIcon() => SvgPicture.asset(
    Drawables.icRedirection,
    width: 18,
    height: 18,
    color: AppColors.grey800,
  );
}
