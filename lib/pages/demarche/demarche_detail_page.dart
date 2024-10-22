import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_detail_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_detail_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';
import 'package:pass_emploi_app/widgets/connectivity_widgets.dart';
import 'package:pass_emploi_app/widgets/date_echeance_in_detail.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/info_card.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

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
      child: ConfettiWrapper(builder: (context, conffetiController) {
        return Scaffold(
          appBar: SecondaryAppBar(
            title: Strings.demarcheDetails,
            actions: [_MoreButton(demarcheId: id)],
          ),
          body: StoreConnector<AppState, DemarcheDetailViewModel>(
            converter: (store) => DemarcheDetailViewModel.create(store, id),
            onDidChange: (oldViewModel, newViewModel) async {
              if (newViewModel.updateDisplayState == DisplayState.FAILURE) {
                showSnackBarWithSystemError(context, Strings.updateStatusError);
                newViewModel.resetUpdateStatus();
              }
            },
            onDispose: (store) => store.dispatch(UpdateDemarcheResetAction()),
            builder: (context, viewModel) => _Body(viewModel, onDemarcheDone: () {
              conffetiController.play();
            }),
            distinct: true,
          ),
        );
      }),
    );
  }
}

class _Body extends StatelessWidget {
  final DemarcheDetailViewModel viewModel;
  final VoidCallback onDemarcheDone;

  _Body(this.viewModel, {required this.onDemarcheDone});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            if (viewModel.withOfflineBehavior) ConnectivityBandeau(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (viewModel.withDateDerniereMiseAJour != null)
                        InfoCard(message: viewModel.withDateDerniereMiseAJour!),
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
                      _StatusSelector(viewModel: viewModel, onDemarcheDone: onDemarcheDone),
                      SizedBox(height: Margins.spacing_base),
                      _HistoriqueTitle(),
                      SizedBox(height: Margins.spacing_base),
                      _Historique(viewModel),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (viewModel.updateDisplayState == DisplayState.LOADING) LoadingOverlay(),
      ],
    );
  }
}

class _StatusSelector extends StatelessWidget {
  final DemarcheDetailViewModel viewModel;
  final VoidCallback onDemarcheDone;

  const _StatusSelector({required this.viewModel, required this.onDemarcheDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (viewModel.statutsPossibles.isNotEmpty) ...[
          SizedBox(height: Margins.spacing_base),
          _StatutTitle(),
        ],
        if (viewModel.statutsPossibles.isNotEmpty) ...[
          SizedBox(height: Margins.spacing_base),
          _StatutList(viewModel, onDemarcheDone: onDemarcheDone),
          SizedBox(height: Margins.spacing_base),
        ],
      ],
    );
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
    return LargeSectionTitle(label);
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
          Icon(
            AppIcons.place_outlined,
            color: AppColors.grey700,
            size: Dimens.icon_size_m,
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
  final VoidCallback onDemarcheDone;

  _StatutList(this.viewModel, {required this.onDemarcheDone});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children:
          viewModel.statutsPossibles.map((e) => _StatutItem(e, viewModel, onDemarcheDone: onDemarcheDone)).toList(),
    );
  }
}

class _StatutItem extends StatelessWidget {
  final UserActionTagViewModel statut;
  final DemarcheDetailViewModel viewModel;
  final VoidCallback onDemarcheDone;

  _StatutItem(this.statut, this.viewModel, {required this.onDemarcheDone});

  @override
  Widget build(BuildContext context) {
    final bool isActive = viewModel.withDateDerniereMiseAJour == null && !viewModel.withOfflineBehavior;
    return Opacity(
      opacity: isActive ? 1 : 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isActive
                ? () {
                    viewModel.onModifyStatus(statut);
                    if (getStatusFromTag(statut) == DemarcheStatus.DONE) onDemarcheDone();
                  }
                : null,
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
                    Icon(
                      AppIcons.check_rounded,
                      color: statut.textColor,
                      size: Dimens.icon_size_base,
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
            Text.rich(
              TextSpan(
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
            Text.rich(
              TextSpan(
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

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.demarcheId});

  final String demarcheId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(AppIcons.more_vert_rounded),
      onPressed: () => DemarcheDetailsBottomSheet.show(context, demarcheId),
    );
  }
}
