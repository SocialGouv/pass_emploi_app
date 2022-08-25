import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_detail.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class DemarcheDetailPage extends StatelessWidget {
  final String id;

  DemarcheDetailPage._(this.id);

  static MaterialPageRoute<void> materialPageRoute(String id) {
    return MaterialPageRoute(builder: (context) => DemarcheDetailPage._(id));
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.userActionDetails,
      child: Scaffold(
        appBar: passEmploiAppBar(label: Strings.demarcheDetails, context: context),
        body: StoreConnector<AppState, DemarcheDetailViewModel>(
          converter: (store) => DemarcheDetailViewModel.create(store, id),
          onDidChange: (oldViewModel, newViewModel)  async {
            if (newViewModel.errorOnUpdate) {
              showFailedSnackBar(context, Strings.updateStatusError);
              newViewModel.resetUpdateStatus();
            }
          },
          onDispose: (store) => store.dispatch(UpdateDemarcheResetAction()),
          builder: (context, viewModel) => _Body(viewModel),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final DemarcheDetailViewModel viewModel;

  _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (viewModel.label != null) ...[
                  SizedBox(height: Margins.spacing_base),
                  _Categorie(viewModel.label!),
                ],
                if (viewModel.titreDetail != null) ...[
                  SizedBox(height: Margins.spacing_base),
                  _Titre(viewModel.titreDetail!),
                ],
                if (viewModel.sousTitre != null) ...[
                  SizedBox(height: Margins.spacing_base),
                  _SousTitre(viewModel.sousTitre!),
                ],
                SizedBox(height: Margins.spacing_base),
                _DetailDemarcheTitle(),
                if (viewModel.attributs.isNotEmpty) ...[
                  SizedBox(height: Margins.spacing_base),
                  _Attributs(viewModel.attributs),
                ],
                SizedBox(height: Margins.spacing_base),
                DateEcheanceInDetail(
                  icons: viewModel.dateIcons,
                  formattedTexts: viewModel.dateFormattedTexts,
                  backgroundColor: viewModel.dateBackgroundColor,
                  textColor: viewModel.dateTextColor,
                ),
                if (viewModel.statutsPossibles.isNotEmpty) ...[
                  SizedBox(height: Margins.spacing_base),
                  _StatutTitle(),
                ],
                if (viewModel.statutsPossibles.isNotEmpty) ...[
                  SizedBox(height: Margins.spacing_base),
                  _StatutList(viewModel),
                  SizedBox(height: Margins.spacing_base),
                ],
                SizedBox(height: Margins.spacing_base),
                _HistoriqueTitle(),
                SizedBox(height: Margins.spacing_base),
                _Historique(viewModel),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
        if (_loading(viewModel)) LoadingOverlay(),
      ],
    );
  }

  bool _loading(DemarcheDetailViewModel viewModel) {
    return viewModel.updateDisplayState == DisplayState.LOADING;
  }
}

class _Categorie extends StatelessWidget {
  final String label;

  _Categorie(this.label);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.accent2),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        child: Text(
          label,
          style: TextStyles.textBaseRegularWithColor(AppColors.accent2),
        ),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  final String label;

  _Titre(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.textLBold(color: AppColors.primary),
    );
  }
}

class _SousTitre extends StatelessWidget {
  final String label;

  _SousTitre(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyles.textBaseRegular,
    );
  }
}

class _Attributs extends StatelessWidget {
  final List<String> attributs;

  _Attributs(this.attributs);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: attributs.map((e) => _AttributItem(e)).toList(),
    );
  }
}

class _AttributItem extends StatelessWidget {
  final String label;

  _AttributItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            Drawables.icPlace,
            color: AppColors.grey700,
            height: Margins.spacing_m,
          ),
          SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyles.textBaseBold)),
        ],
      ),
    );
  }
}

class _DetailDemarcheTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(color: AppColors.primaryLighten, height: 1),
        SizedBox(height: 20),
        Text(Strings.demarcheDetails, style: TextStyles.textBaseBold),
      ],
    );
  }
}

class _StatutTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(color: AppColors.primaryLighten, height: 1),
        SizedBox(
          height: 20,
        ),
        Text(Strings.modifierStatut, style: TextStyles.textBaseBold),
      ],
    );
  }
}

class _StatutList extends StatelessWidget {
  final DemarcheDetailViewModel viewModel;

  _StatutList(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: viewModel.statutsPossibles.map((e) => _StatutItem(e, viewModel)).toList(),
    );
  }
}

class _StatutItem extends StatelessWidget {
  final UserActionTagViewModel statut;
  final DemarcheDetailViewModel viewModel;

  _StatutItem(this.statut, this.viewModel);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(40)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            viewModel.onModifyStatus(statut);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              color: statut.backgroundColor,
              border: Border.all(color: statut.textColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (statut.isSelected)
                  SvgPicture.asset(
                    Drawables.icDone,
                    color: statut.textColor,
                    height: 14,
                    width: 14,
                  ),
                if (statut.isSelected) SizedBox(width: 10),
                Text(
                  statut.title,
                  style: TextStyles.textSRegularWithColor(statut.textColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoriqueTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(color: AppColors.primaryLighten, height: 1),
        SizedBox(
          height: 20,
        ),
        Text(Strings.historiqueDemarche, style: TextStyles.textBaseBold),
      ],
    );
  }
}

class _Historique extends StatelessWidget {
  final DemarcheDetailViewModel viewModel;

  _Historique(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(color: AppColors.grey500, width: 1),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (viewModel.modificationDate != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: Strings.modifiedBy, style: TextStyles.textBaseRegular),
                  TextSpan(text: viewModel.modificationDate, style: TextStyles.textBaseBold),
                  if (viewModel.modifiedByAdvisor) TextSpan(text: Strings.par, style: TextStyles.textBaseRegular),
                  if (viewModel.modifiedByAdvisor)
                    TextSpan(text: Strings.votreConseiller, style: TextStyles.textBaseBold),
                ],
              ),
            ),
          if (viewModel.creationDate != null)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: Strings.createdBy, style: TextStyles.textBaseRegular),
                  TextSpan(text: viewModel.creationDate, style: TextStyles.textBaseBold),
                  if (viewModel.createdByAdvisor) TextSpan(text: Strings.par, style: TextStyles.textBaseRegular),
                  if (viewModel.createdByAdvisor)
                    TextSpan(text: Strings.votreConseiller, style: TextStyles.textBaseBold),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
