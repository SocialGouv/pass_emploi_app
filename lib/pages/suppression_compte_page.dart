import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/profil/suppression_compte_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/dialogs/delete_user_dialog.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
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
        onDidChange: (_, newVM) {
          if (newVM.displayState == DisplayState.FAILURE) {
            showSnackBarWithSystemError(context, Strings.alerteDeleteError);
          } else if (newVM.displayState == DisplayState.CONTENT) {
            showAdaptiveDialog(context: context, builder: (_) => _DeleteAccountSuccessDialog());
          }
        },
        distinct: true,
      ),
    );
  }

  Widget _scaffold(BuildContext context, SuppressionCompteViewModel viewModel) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.suppressionPageTitle),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _DeleteAccountButton(),
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
      if (viewModel.displayState == DisplayState.LOADING)
        Container(
          color: Colors.white.withOpacity(0.5),
          child: Center(
            child: CircularProgressIndicator(),
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: PrimaryActionButton(
          onPressed: () => _showDeleteDialog(context),
          label: Strings.suppressionButtonLabel,
          textColor: AppColors.warning,
          fontSize: FontSizes.normal,
          backgroundColor: AppColors.warningLighten,
          disabledBackgroundColor: AppColors.warningLighten,
          rippleColor: AppColors.warningLighten,
          withShadow: false,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) => showDialog(
        context: context,
        builder: (_) {
          PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.suppressionAccountConfirmation);
          return DeleteAlertDialog();
        },
      );
}

class _DeleteAccountSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.all(Margins.spacing_m),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          SizedBox.square(
            dimension: 100,
            child: Illustration.green(AppIcons.check_rounded),
          ),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.accountDeletionSuccess, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_m),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.closeDialog,
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
