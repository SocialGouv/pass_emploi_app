import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche/create_demarche_success_page.dart';
import 'package:pass_emploi_app/presentation/user_action/postuler_confirmation_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/create_user_action_confirmation_offre_suivi_page.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class PostulerConfirmationPage extends StatelessWidget {
  const PostulerConfirmationPage({required this.offreId});

  final String offreId;

  static Route<void> route(String offreId) {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => PostulerConfirmationPage(offreId: offreId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PostulerConfirmationViewModel>(
        converter: (store) => PostulerConfirmationViewModel.create(store, offreId),
        builder: (context, viewModel) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: SecondaryAppBar(
              title: Strings.offrePostuleeConfirmationAppBar,
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Margins.spacing_xl),
                    Center(
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: Illustration.green(AppIcons.check_rounded),
                      ),
                    ),
                    SizedBox(height: Margins.spacing_xl),
                    Text(
                      Strings.offreSuivieConfirmationPageTitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.textMBold,
                    ),
                    SizedBox(height: Margins.spacing_base),
                    Text(
                      Strings.offreSuivieConfirmationPageDescription,
                      textAlign: TextAlign.center,
                      style: TextStyles.textBaseRegular,
                    ),
                    SizedBox(height: Margins.spacing_l),
                    Text(
                      viewModel.wishToCreateActionOrDemarche,
                      textAlign: TextAlign.center,
                      style: TextStyles.textBaseRegular,
                    ),
                    SizedBox(height: Margins.spacing_base),
                    PrimaryActionButton(
                      label: viewModel.onCreateActionOrDemarcheLabel,
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModel.onCreateActionOrDemarche();
                        if (viewModel.useDemarche) {
                          Navigator.of(context)
                              .push(CreateDemarcheSuccessPage.route(CreateDemarcheSource.fromReferentiel));
                        } else {
                          Navigator.of(context).push(CreateUserActionConfirmationOffreSuiviPage.route());
                        }
                      },
                    ),
                    SizedBox(height: Margins.spacing_base),
                    SecondaryButton(
                      label: Strings.close,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
