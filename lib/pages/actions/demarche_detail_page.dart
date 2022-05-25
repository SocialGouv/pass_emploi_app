import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class DemarcheDetailPage extends TraceableStatelessWidget {
  final UserActionPEViewModel viewModel;

  DemarcheDetailPage._(this.viewModel) : super(name: AnalyticsScreenNames.userActionDetails);

  static MaterialPageRoute<void> materialPageRoute(
      UserActionPEViewModel actionViewModel) {
    return MaterialPageRoute(
        builder: (context) => DemarcheDetailPage._(actionViewModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          passEmploiAppBar(label: Strings.demarcheDetails, context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (viewModel.label != null) _Categorie(viewModel.label!),
            if (viewModel.titreDetail != null) _Titre(viewModel.titreDetail!),
            if (viewModel.sousTitre != null) _SousTitre(viewModel.sousTitre!),
            _DetailDemarcheTitle(),
            if (viewModel.attributs.isNotEmpty) _Attributs(viewModel.attributs),
            _EndDate(viewModel.formattedDate),
            if (viewModel.statutsPossibles.isNotEmpty) _StatutTitle(),
            if (viewModel.statutsPossibles.isNotEmpty)
              _StatutList(viewModel.statutsPossibles),
            _HistoriqueTitle(),
            _Historique(viewModel),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Categorie extends StatelessWidget {
  final String label;

  _Categorie(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Align(
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
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  final String label;

  _Titre(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Text(
        label,
        style: TextStyles.textLBold(color: AppColors.primary),
      ),
    );
  }
}

class _SousTitre extends StatelessWidget {
  final String label;

  _SousTitre(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Text(
        label,
        style: TextStyles.textBaseRegular,
      ),
    );
  }
}

class _Attributs extends StatelessWidget {
  final List<String> attributs;

  _Attributs(this.attributs);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: attributs.map((e) => _AttributItem(e)).toList(),
      ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(color: AppColors.primaryLighten, height: 1),
          SizedBox(
            height: 20,
          ),
          Text(Strings.demarcheDetails, style: TextStyles.textBaseBold),
        ],
      ),
    );
  }
}

class _EndDate extends StatelessWidget {
  final String label;

  _EndDate(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.accent3Lighten,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              Drawables.icClock,
              color: AppColors.grey700,
              height: 20,
            ),
            SizedBox(width: 12),
            Expanded(child: Text(label, style: TextStyles.textBaseRegular)),
          ],
        ),
      ),
    );
  }
}

class _StatutTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(color: AppColors.primaryLighten, height: 1),
          SizedBox(
            height: 20,
          ),
          Text(Strings.modifierStatut, style: TextStyles.textBaseBold),
        ],
      ),
    );
  }
}

class _StatutList extends StatelessWidget {
  final List<UserActionTagViewModel> statutsPossibles;

  _StatutList(this.statutsPossibles);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: statutsPossibles.map((e) => _StatutItem(e)).toList(),
      ),
    );
  }
}

class _StatutItem extends StatelessWidget {
  final UserActionTagViewModel statut;

  _StatutItem(this.statut);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _HistoriqueTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(color: AppColors.primaryLighten, height: 1),
          SizedBox(
            height: 20,
          ),
          Text(Strings.historiqueDemarche, style: TextStyles.textBaseBold),
        ],
      ),
    );
  }
}

class _Historique extends StatelessWidget {
  final UserActionPEViewModel viewModel;

  _Historique(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, right: 20),
      child: Container(
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
                    TextSpan(
                        text: Strings.modifiedBy,
                        style: TextStyles.textBaseRegular),
                    TextSpan(
                        text: viewModel.modificationDate,
                        style: TextStyles.textBaseBold),
                    if (viewModel.createdByAdvisor)
                      TextSpan(
                          text: Strings.par, style: TextStyles.textBaseRegular),
                    if (viewModel.createdByAdvisor)
                      TextSpan(
                          text: Strings.votreConseiller,
                          style: TextStyles.textBaseBold),
                  ],
                ),
              ),
            if (viewModel.creationDate != null)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: Strings.createdBy,
                        style: TextStyles.textBaseRegular),
                    TextSpan(
                        text: viewModel.creationDate,
                        style: TextStyles.textBaseBold),
                    if (viewModel.createdByAdvisor)
                      TextSpan(
                          text: Strings.par, style: TextStyles.textBaseRegular),
                    if (viewModel.createdByAdvisor)
                      TextSpan(
                          text: Strings.votreConseiller,
                          style: TextStyles.textBaseBold),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
