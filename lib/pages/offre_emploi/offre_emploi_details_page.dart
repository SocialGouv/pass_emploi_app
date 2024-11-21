import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_consultation_offre_actions.dart';
import 'package:pass_emploi_app/features/derniere_offre_consultee/derniere_offre_consultee_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/pages/chat/chat_partage_bottom_sheet.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/postuler_offre_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/delete_favori_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/buttons/share_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/favori_not_found_error.dart';
import 'package:pass_emploi_app/widgets/external_link.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/help_tooltip.dart';
import 'package:pass_emploi_app/widgets/in_app_feedback.dart';
import 'package:pass_emploi_app/widgets/offre_emploi_origin.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/tags/data_tag.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';

class OffreEmploiDetailsPage extends StatelessWidget {
  final String _offreId;
  final bool _fromAlternance;
  final bool popPageWhenFavoriIsRemoved;

  OffreEmploiDetailsPage._(
    this._offreId,
    this._fromAlternance, {
    this.popPageWhenFavoriIsRemoved = false,
  });

  static MaterialPageRoute<void> materialPageRoute(
    String id, {
    required bool fromAlternance,
    bool popPageWhenFavoriIsRemoved = false,
  }) {
    return MaterialPageRoute(builder: (context) {
      return OffreEmploiDetailsPage._(
        id,
        fromAlternance,
        popPageWhenFavoriIsRemoved: popPageWhenFavoriIsRemoved,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: _fromAlternance ? AnalyticsScreenNames.alternanceDetails : AnalyticsScreenNames.emploiDetails,
      child: StoreConnector<AppState, OffreEmploiDetailsPageViewModel>(
        onInit: (store) => store.dispatch(OffreEmploiDetailsRequestAction(_offreId)),
        onInitialBuild: (_) {
          context.trackEvenementEngagement(_offreAfficheeEvent());
        },
        converter: (store) => OffreEmploiDetailsPageViewModel.create(store),
        builder: (context, viewModel) => FavorisStateContext<OffreEmploi>(
          selectState: (store) => store.state.offreEmploiFavorisIdsState,
          child: _scaffold(_body(context, viewModel), context),
        ),
        onDispose: (store) {
          store.dispatch(DateConsultationWriteOffreAction(_offreId));
          store.dispatch(DerniereOffreEmploiConsulteeWriteAction());
        },
      ),
    );
  }

  Widget _body(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    return switch (viewModel.displayState) {
      OffreEmploiDetailsPageDisplayState.SHOW_DETAILS => _content(context, viewModel),
      OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS => _content(context, viewModel),
      OffreEmploiDetailsPageDisplayState.SHOW_LOADER => _loading(),
      OffreEmploiDetailsPageDisplayState.SHOW_ERROR => _error()
    };
  }

  Scaffold _scaffold(Widget body, BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.offreDetails, backgroundColor: backgroundColor),
      body: body,
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _error() => Center(child: Text(Strings.offreDetailsError));

  Widget _content(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    final id = viewModel.id;
    final title = viewModel.title;
    final url = viewModel.urlRedirectPourPostulation;
    final companyName = viewModel.companyName;
    final lastUpdate = viewModel.lastUpdate;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppFeedback(
                  feature: 'provenance-offre',
                  label: Strings.feedbackProvenanceOffre,
                  padding: const EdgeInsets.only(bottom: Margins.spacing_m),
                ),
                if (id != null) Text(Strings.offreDetailNumber(id), style: TextStyles.textXsRegular()),
                if (lastUpdate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: Margins.spacing_xs),
                    child: Text(
                      Strings.offreDetailLastUpdate(lastUpdate),
                      style: TextStyles.textSRegular(),
                    ),
                  ),
                SizedBox(height: Margins.spacing_s),
                if (viewModel.originViewModel != null) ...[
                  OffreEmploiOrigin(
                    label: viewModel.originViewModel!.name,
                    source: viewModel.originViewModel!.source,
                    size: OffreEmploiOriginSize.medium,
                  ),
                  SizedBox(height: Margins.spacing_s),
                ],
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Margins.spacing_m),
                    child: Semantics(
                      header: true,
                      child: Text(title, style: TextStyles.textLBold()),
                    ),
                  ),
                if (companyName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Margins.spacing_m),
                    child: Text(companyName, style: TextStyles.textBaseRegular),
                  ),
                _tags(viewModel),
                if (viewModel.dateDerniereConsultation != null) ...[
                  CardComplement.dateDerniereConsultation(viewModel.dateDerniereConsultation!),
                  SizedBox(height: Margins.spacing_base),
                ],
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS)
                  _PartageOffre(isAlternance: _fromAlternance),
                SizedBox(height: Margins.spacing_l),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS) _description(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS)
                  _profileDescription(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS)
                  if (viewModel.companyName != null) _companyDescription(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS)
                  FavoriNotFoundError(),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
        if (url != null && id != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: _footer(context, viewModel.shouldShowCvBottomSheet, url, id, viewModel.title),
          )
        else if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS && id != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: _incompleteDataFooter(context, id),
          )
      ],
    );
  }

  Widget _tags(OffreEmploiDetailsPageViewModel viewModel) {
    final location = viewModel.location;
    final contractType = viewModel.contractType;
    final salary = viewModel.salary;
    final duration = viewModel.duration;
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: Wrap(
        spacing: Margins.spacing_s,
        runSpacing: Margins.spacing_s,
        children: [
          if (location != null) DataTag.location(location),
          if (contractType != null) DataTag.contractType(contractType),
          if (salary != null)
            DataTag(
              label: salary,
              iconSemantics: IconWithSemantics(AppIcons.euro_rounded, Strings.iconAlternativeSalary),
            ),
          if (duration != null) DataTag.duration(duration),
        ],
      ),
    );
  }

  Widget _description(OffreEmploiDetailsPageViewModel viewModel) {
    final description = viewModel.description;
    if (description == null) {
      return SizedBox.shrink();
    }

    final paragraphs = description.split("\n").where((paragraph) => paragraph.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.offreDetailsTitle),
        SizedBox(height: Margins.spacing_m),
        ...paragraphs.map((paragraph) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(paragraph, style: TextStyles.textSRegular()),
            ],
          );
        }),
        SizedBox(height: Margins.spacing_l),
      ],
    );
  }

  Widget _profileDescription(OffreEmploiDetailsPageViewModel viewModel) {
    final experience = viewModel.experience;
    final Widget? skills = _skillsBlock(skills: viewModel.skills);
    final Widget? softSkills = _softSkillsBlock(softSkills: viewModel.softSkills);
    final Widget? educations = _educationsBlock(educations: viewModel.educations);
    final Widget? languages = _languagesBlock(languages: viewModel.languages);
    final Widget? driverLicences = _driverLicencesBlock(driverLicences: viewModel.driverLicences);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.profileTitle),
        SizedBox(height: Margins.spacing_m),
        Text(Strings.experienceTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        if (experience != null) _setRequiredElement(element: experience, criteria: viewModel.requiredExperience),
        SepLine(Margins.spacing_m, Margins.spacing_m),
        if (skills != null) skills,
        if (softSkills != null) softSkills,
        if (educations != null) educations,
        if (languages != null) languages,
        if (driverLicences != null) driverLicences,
      ],
    );
  }

  Widget _companyDescription(OffreEmploiDetailsPageViewModel viewModel) {
    final companyName = viewModel.companyName;
    final companyDescription = viewModel.companyDescription;
    final companyAdapted = viewModel.companyAdapted != null ? viewModel.companyAdapted! : false;
    final companyAccessibility = viewModel.companyAccessibility != null ? viewModel.companyAccessibility! : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.companyTitle),
        SizedBox(height: Margins.spacing_m),
        if (companyName != null) _companyName(companyName: companyName, companyUrl: viewModel.companyUrl),
        if (companyAdapted) _blueTag(tagTitle: Strings.companyAdaptedTitle),
        if (companyAccessibility) _blueTag(tagTitle: Strings.companyAccessibilityTitle),
        SizedBox(height: Margins.spacing_m),
        if (companyDescription != null) _companyDescriptionBlock(content: companyDescription),
      ],
    );
  }

  Widget _descriptionTitle({required String title}) {
    return TitleSection(label: title);
  }

  Widget _companyDescriptionBlock({required String content}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Strings.companyDescriptionTitle, style: TextStyles.textBaseBold),
      SizedBox(height: Margins.spacing_base),
      Text(content, style: TextStyles.textSRegular()),
      SepLine(Margins.spacing_base, Margins.spacing_m),
    ]);
  }

  Widget? _skillsBlock({required List<Skill>? skills}) {
    if (skills == null || skills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.skillsTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        for (final skill in skills) _setRequiredElement(element: skill.description, criteria: skill.requirement),
        SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  Widget? _softSkillsBlock({required List<String>? softSkills}) {
    if (softSkills == null || softSkills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.softSkillsTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        for (final soft in softSkills)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_m),
            child: Text("· $soft", style: TextStyles.textSRegular()),
          ),
        SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  Widget? _educationsBlock({required List<EducationViewModel>? educations}) {
    if (educations == null || educations.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.educationTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        for (final education in educations)
          _setRequiredElement(element: education.label, criteria: education.requirement),
        SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  Widget? _languagesBlock({required List<Language>? languages}) {
    if (languages == null || languages.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.languageTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        for (final language in languages) _setRequiredElement(element: language.type, criteria: language.requirement),
        SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  Widget? _driverLicencesBlock({required List<DriverLicence>? driverLicences}) {
    if (driverLicences == null || driverLicences.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.driverLicenceTitle, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        for (final licence in driverLicences)
          _setRequiredElement(element: licence.category, criteria: licence.requirement),
        SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  Widget _blueTag({required String tagTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Margins.spacing_base),
        DataTag(label: tagTitle),
      ],
    );
  }

  Widget _setRequiredElement({required String element, required String? criteria}) {
    return _require(criteria) ? _requiredElement(element) : _listItem(element);
  }

  bool _require(String? criteria) => (criteria != null && criteria == "E");

  Widget _listItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: Text("· $text", style: TextStyles.textSRegular()),
    );
  }

  Widget _requiredElement(String requiredText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _listItem(requiredText)),
          Padding(
            padding: const EdgeInsets.only(left: Margins.spacing_s, bottom: Margins.spacing_base),
            child: HelpTooltip(message: Strings.requiredIcon, icon: AppIcons.error_rounded),
          ),
        ],
      ),
    );
  }

  Widget _companyName({required String companyName, required String? companyUrl}) {
    return (companyUrl == null || companyUrl.isEmpty)
        ? Text(companyName, style: TextStyles.textBaseBold)
        : _companyNameWithUrl(companyName: companyName, url: companyUrl);
  }

  Widget _companyNameWithUrl({required String companyName, required String url}) {
    return ExternalLink(
      label: companyName,
      url: url,
    );
  }

  Widget _footer(BuildContext context, bool shouldShowCvBottomSheet, String url, String offreId, String? title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Semantics(
              link: true,
              child: PrimaryActionButton(
                onPressed: () {
                  if (shouldShowCvBottomSheet) {
                    showPassEmploiBottomSheet(
                      context: context,
                      builder: (context) => PostulerOffreBottomSheet(
                        onPostuler: () => _applyToOffer(context, url),
                      ),
                    );
                  } else {
                    _applyToOffer(context, url);
                  }
                },
                label: Strings.postulerButtonTitle,
                icon: shouldShowCvBottomSheet ? null : AppIcons.open_in_new_rounded,
              ),
            ),
          ),
          SizedBox(width: Margins.spacing_base),
          FavoriHeart<OffreEmploi>(
            offreId: offreId,
            withBorder: true,
            from: _fromAlternance ? OffrePage.alternanceDetails : OffrePage.emploiDetails,
            onFavoriRemoved: popPageWhenFavoriIsRemoved ? () => Navigator.pop(context) : null,
          ),
          SizedBox(width: Margins.spacing_base),
          ShareButton(
            textToShare: url,
            semanticsLabel: Strings.a11yPartagerOffreLabel,
            subjectForEmail: title,
            onPressed: () => _shareOffer(context),
          ),
        ],
      ),
    );
  }

  Padding _incompleteDataFooter(BuildContext context, String id) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: DeleteFavoriButton<OffreEmploi>(offreId: id, from: OffrePage.emploiDetails)),
        ],
      ),
    );
  }

  void _applyToOffer(BuildContext context, String url) {
    launchExternalUrl(url);
    context.trackEvenementEngagement(_postulerEvent());
  }

  void _shareOffer(BuildContext context) => context.trackEvenementEngagement(_partagerEvent());

  EvenementEngagement _offreAfficheeEvent() {
    return _fromAlternance ? EvenementEngagement.OFFRE_ALTERNANCE_AFFICHEE : EvenementEngagement.OFFRE_EMPLOI_AFFICHEE;
  }

  EvenementEngagement _postulerEvent() =>
      _fromAlternance ? EvenementEngagement.OFFRE_ALTERNANCE_POSTULEE : EvenementEngagement.OFFRE_EMPLOI_POSTULEE;

  EvenementEngagement _partagerEvent() =>
      _fromAlternance ? EvenementEngagement.OFFRE_ALTERNANCE_PARTAGEE : EvenementEngagement.OFFRE_EMPLOI_PARTAGEE;
}

class _PartageOffre extends StatelessWidget {
  final bool isAlternance;

  const _PartageOffre({required this.isAlternance});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SecondaryButton(
        onPressed: () => ChatPartageBottomSheet.show(
          context,
          ChatPartageOffreEmploiSource(isAlternance ? OffreType.alternance : OffreType.emploi),
        ),
        label: Strings.partagerOffreConseiller,
      ),
    );
  }
}
