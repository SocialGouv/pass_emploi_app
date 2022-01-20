import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/favori_heart_view_model.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/external_link.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/help_tooltip.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/share_button.dart';
import 'package:pass_emploi_app/widgets/tags.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';
import 'package:url_launcher/url_launcher.dart';

class OffreEmploiDetailsPage extends TraceableStatelessWidget {
  final String _offreId;
  final bool _fromAlternance;
  final bool shouldPopPageWhenFavoriIsRemoved;

  OffreEmploiDetailsPage._(
    this._offreId,
    this._fromAlternance, {
    this.shouldPopPageWhenFavoriIsRemoved = false,
  }) : super(name: _fromAlternance ? AnalyticsScreenNames.alternanceDetails : AnalyticsScreenNames.emploiDetails);

  static MaterialPageRoute materialPageRoute(
    String id, {
    required bool fromAlternance,
    bool shouldPopPageWhenFavoriIsRemoved = false,
  }) {
    return MaterialPageRoute(builder: (context) {
      return OffreEmploiDetailsPage._(
        id,
        fromAlternance,
        shouldPopPageWhenFavoriIsRemoved: shouldPopPageWhenFavoriIsRemoved,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiDetailsPageViewModel>(
      onInit: (store) => store.dispatch(OffreEmploiDetailsAction.request(_offreId)),
      onInitialBuild: (_) {
        context.trackEvent(_offreAfficheeEvent());
      },
      converter: (store) => OffreEmploiDetailsPageViewModel.getDetails(store),
      builder: (context, viewModel) => FavorisStateContext<OffreEmploi>(
        selectState: (store) => store.state.offreEmploiFavorisState,
        child: _scaffold(_body(context, viewModel)),
      ),
    );
  }

  Widget _body(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case OffreEmploiDetailsPageDisplayState.SHOW_DETAILS:
      case OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS:
        return _content(context, viewModel);
      case OffreEmploiDetailsPageDisplayState.SHOW_LOADER:
        return _loading();
      case OffreEmploiDetailsPageDisplayState.SHOW_ERROR:
        return _error();
    }
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      appBar: passEmploiAppBar(label: Strings.offreDetails, withBackButton: true),
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
            padding: const EdgeInsets.fromLTRB(Margins.medium, Margins.medium, Margins.medium, 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (id != null) Text(Strings.offreDetailNumber(id), style: TextStyles.textXsRegular()),
                if (lastUpdate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      Strings.offreDetailLastUpdate(lastUpdate),
                      style: TextStyles.textSRegular(),
                    ),
                  ),
                _spacer(18),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(title, style: TextStyles.textLBold()),
                  ),
                if (companyName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(companyName, style: TextStyles.textBaseRegular),
                  ),
                _tags(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS) _description(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS)
                  _profileDescription(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_DETAILS)
                  if (viewModel.companyName != null) _companyDescription(viewModel),
                if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS)
                  _offreNotFoundError(),
                _spacer(60),
              ],
            ),
          ),
        ),
        if (url != null && id != null)
          Align(
            child: _footer(context, url, id, viewModel.title),
            alignment: Alignment.bottomCenter,
          )
        else if (viewModel.displayState == OffreEmploiDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS && id != null)
          Align(
            child: _incompleteDataFooter(context, id),
            alignment: Alignment.bottomCenter,
          )
      ],
    );
  }

  Widget _tags(OffreEmploiDetailsPageViewModel viewModel) {
    final location = viewModel.location;
    final contractType = viewModel.contractType;
    final salary = viewModel.salary;
    final duration = viewModel.duration;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (location != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DataTag(label: location, drawableRes: Drawables.icPlace),
        ),
      if (contractType != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DataTag(label: contractType, drawableRes: Drawables.icContract),
        ),
      if (salary != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DataTag(label: salary, drawableRes: Drawables.icSalary),
        ),
      if (duration != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DataTag(label: duration, drawableRes: Drawables.icTime),
        ),
    ]);
  }

  Widget _description(OffreEmploiDetailsPageViewModel viewModel) {
    final description = viewModel.description;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _descriptionTitle(title: Strings.offreDetailsTitle),
      _spacer(12),
      if (description != null) Text(description, style: TextStyles.textSRegular()),
      _spacer(30),
    ]);
  }

  Widget _profileDescription(OffreEmploiDetailsPageViewModel viewModel) {
    final experience = viewModel.experience;
    Widget? skills = _skillsBlock(skills: viewModel.skills);
    Widget? softSkills = _softSkillsBlock(softSkills: viewModel.softSkills);
    Widget? educations = _educationsBlock(educations: viewModel.educations);
    Widget? languages = _languagesBlock(languages: viewModel.languages);
    Widget? driverLicences = _driverLicencesBlock(driverLicences: viewModel.driverLicences);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.profileTitle),
        _spacer(20),
        Text(Strings.experienceTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        if (experience != null) _setRequiredElement(element: experience, criteria: viewModel.requiredExperience),
        SepLine(20, 20),
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
        if (companyName != null) _companyName(companyName: companyName, companyUrl: viewModel.companyUrl),
        if (companyAdapted) _blueTag(tagTitle: Strings.companyAdaptedTitle),
        if (companyAccessibility) _blueTag(tagTitle: Strings.companyAccessibilityTitle),
        _spacer(20),
        if (companyDescription != null) _companyDescriptionBlock(content: companyDescription),
      ],
    );
  }

  Widget _spacer(double _height) => SizedBox(height: _height);

  Widget _descriptionTitle({required String title}) {
    return TitleSection(label: title);
  }

  Widget _companyDescriptionBlock({required String content}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Strings.companyDescriptionTitle, style: TextStyles.textBaseBold),
      _spacer(12),
      Text(content, style: TextStyles.textSRegular()),
      SepLine(12, 20),
    ]);
  }

  Widget? _skillsBlock({required List<Skill>? skills}) {
    if (skills == null || skills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.skillsTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        for (final skill in skills) _setRequiredElement(element: skill.description, criteria: skill.requirement),
        SepLine(20, 20),
      ],
    );
  }

  Widget? _softSkillsBlock({required List<String>? softSkills}) {
    if (softSkills == null || softSkills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.softSkillsTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        for (final soft in softSkills)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("· $soft", style: TextStyles.textSRegular()),
          ),
        SepLine(20, 20),
      ],
    );
  }

  Widget? _educationsBlock({required List<EducationViewModel>? educations}) {
    if (educations == null || educations.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.educationTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        for (final education in educations)
          _setRequiredElement(element: education.label, criteria: education.requirement),
        SepLine(20, 20),
      ],
    );
  }

  Widget? _languagesBlock({required List<Language>? languages}) {
    if (languages == null || languages.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.languageTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        for (final language in languages) _setRequiredElement(element: language.type, criteria: language.requirement),
        SepLine(20, 20),
      ],
    );
  }

  Widget? _driverLicencesBlock({required List<DriverLicence>? driverLicences}) {
    if (driverLicences == null || driverLicences.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.driverLicenceTitle, style: TextStyles.textBaseBold),
        _spacer(12),
        for (final licence in driverLicences)
          _setRequiredElement(element: licence.category, criteria: licence.requirement),
        SepLine(20, 20),
      ],
    );
  }

  Widget _blueTag({required String tagTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _spacer(12),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text("· $text", style: TextStyles.textSRegular()),
    );
  }

  Widget _requiredElement(String requiredText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: _listItem(requiredText)),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 12),
            child: HelpTooltip(message: Strings.requiredIcon, iconRes: Drawables.icImportant),
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

  Widget _offreNotFoundError() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: AppColors.franceRedAlpha05,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                Strings.offreNotFoundError,
                style: TextStyles.textSBoldWithColor(
                  AppColors.franceRed,
                ),
              ),
              SizedBox(height: 8),
              Text(
                Strings.offreNotFoundExplaination,
                style: TextStyles.textSmRegular(color: AppColors.franceRed),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(BuildContext context, String url, String offreId, String? title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PrimaryActionButton(
              onPressed: () => _applyToOffer(context, url),
              label: Strings.postulerButtonTitle,
            ),
          ),
          SizedBox(width: 16),
          FavoriHeart<OffreEmploi>(
            offreId: offreId,
            withBorder: true,
            from: _fromAlternance ? OffrePage.alternanceDetails : OffrePage.emploiDetails,
            onFavoriRemoved: shouldPopPageWhenFavoriIsRemoved ? () => Navigator.pop(context) : null,
          ),
          SizedBox(width: 16),
          ShareButton(url, title, () => _shareOffer(context)),
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
          Expanded(child: _deleteFavoriStoreConnector(context, id)),
        ],
      ),
    );
  }

  Widget _deleteFavoriStoreConnector(BuildContext context, String offreId) {
    return StoreConnector<AppState, FavoriHeartViewModel>(
      builder: (context, vm) {
        return PrimaryActionButton(
          label: Strings.deleteOffreFromFavori,
          onPressed: vm.withLoading ? null : () => vm.update(false),
        );
      },
      converter: (store) => FavoriHeartViewModel.create(offreId, store, store.state.offreEmploiFavorisState),
      distinct: true,
      onDidChange: (_, viewModel) {
        if (!viewModel.isFavori) {
          Navigator.pop(context);
        }
      },
    );
  }

  void _applyToOffer(BuildContext context, String url) {
    launch(url);
    context.trackEvent(_postulerEvent());
  }

  void _shareOffer(BuildContext context) {
    context.trackEvent(_partagerEvent());
  }

  EventType _offreAfficheeEvent() {
    if (_fromAlternance)
      return EventType.OFFRE_ALTERNANCE_AFFICHEE;
    else
      return EventType.OFFRE_EMPLOI_AFFICHEE;
  }

  EventType _postulerEvent() {
    if (_fromAlternance)
      return EventType.OFFRE_ALTERNANCE_POSTULEE;
    else
      return EventType.OFFRE_EMPLOI_POSTULEE;
  }

  EventType _partagerEvent() {
    if (_fromAlternance)
      return EventType.OFFRE_ALTERNANCE_PARTAGEE;
    else
      return EventType.OFFRE_EMPLOI_PARTAGEE;
  }
}
