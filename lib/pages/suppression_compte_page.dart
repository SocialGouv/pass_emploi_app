import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/profil/suppression_compte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/dialogs/delete_user_dialog.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class SuppressionComptePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => SuppressionComptePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.suppressionAccount,
      child: StoreConnector<AppState, SuppressionCompteViewModel>(
        converter: (store) => SuppressionCompteViewModel.create(store),
        builder: (context, viewModel) => _scaffold(context, viewModel),
      ),
    );
  }

  Widget _scaffold(BuildContext context, SuppressionCompteViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.suppressionPageTitle),
      body: _body(viewModel),
    );
  }

  Widget _body(SuppressionCompteViewModel viewModel) {
    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text(Strings.warning, style: TextStyles.textMBold)),
              SizedBox(height: Margins.spacing_base),
              Text(Strings.warningInformationParagraph1, style: TextStyles.textSRegular()),
              SizedBox(height: Margins.spacing_base),
              _ListedItems(list: viewModel.warningSuppressionFeatures),
              SizedBox(height: Margins.spacing_base),
              Text(Strings.warningInformationParagraph2, style: TextStyles.textSRegular()),
              SizedBox(height: Margins.spacing_base),
              if (viewModel.isPoleEmploiLogin)
                Text(Strings.warningInformationPoleEmploi, style: TextStyles.textSRegular()),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xl, horizontal: Margins.spacing_base),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: _DeleteAccountButton()),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _ListedItems extends StatelessWidget {
  final List<String> list;

  const _ListedItems({required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in list)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_xs),
            child: Text("· $item", style: TextStyles.textSRegular()),
          ),
      ],
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: () => _showDeleteDialog(context),
      label: Strings.suppressionButtonLabel,
      textColor: AppColors.warning,
      fontSize: FontSizes.normal,
      backgroundColor: AppColors.warningLighten,
      disabledBackgroundColor: AppColors.warningLighten,
      rippleColor: AppColors.warningLighten,
      withShadow: false,
    );
  }

  void _showDeleteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) {
        PassEmploiMatomoTracker.instance.trackScreenWithName(
          widgetName: AnalyticsScreenNames.suppressionAccount,
          eventName: AnalyticsActionNames.suppressionAccountConfirmation,
        );
        return DeleteAlertDialog();
      },
    ).then((result) {
      if (result == true) {
        showSuccessfulSnackBar(context, Strings.accountDeletionSuccess);
        PassEmploiMatomoTracker.instance.trackScreenWithName(
          widgetName: AnalyticsScreenNames.suppressionAccount,
          eventName: AnalyticsActionNames.suppressionAccountSucceded,
        );
      } else if (result == false) {
        showFailedSnackBar(context, Strings.savedSearchDeleteError);
      }
    });
  }
}
