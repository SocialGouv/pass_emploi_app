import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/detailed_offer.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/detailed_offer_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/actionButtons.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class OffreEmploiDetailsPage extends TraceableStatelessWidget {
  final String _offerId;

  OffreEmploiDetailsPage._(this._offerId) : super(name: AnalyticsScreenNames.detailsOffreEmploi);

  static MaterialPageRoute materialPageRoute(String id) {
    return MaterialPageRoute(builder: (context) => OffreEmploiDetailsPage._(id));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OffreEmploiDetailsPageViewModel>(
      onInit: (store) => store.dispatch(GetDetailedOfferAction(offerId: _offerId)),
      converter: (store) => OffreEmploiDetailsPageViewModel.getDetails(store),
      builder: (context, viewModel) => _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case OffreEmploiDetailsPageDisplayState.SHOW_DETAILS:
        return _content(context, viewModel);
      case OffreEmploiDetailsPageDisplayState.SHOW_LOADER:
        return _loading(context);
      case OffreEmploiDetailsPageDisplayState.SHOW_ERROR:
        //TODO-65 Gérer l'erreur
        return Container();
    }
  }

  Widget _loading(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightBlue,
        appBar: DefaultAppBar(title: Text(Strings.offerDetails, style: TextStyles.h3Semi)),
        body: Text("is loading ...", style: TextStyles.textMdRegular));
  }

  Widget _content(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    final title = viewModel.title;
    final companyName = viewModel.companyName;
    return Scaffold(
        appBar: DefaultAppBar(title: Text(Strings.offerDetails, style: TextStyles.h3Semi)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Offre n°${viewModel.id}", style: TextStyles.textSmRegular()),
                if (viewModel.lastUpdate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Actualisée le ${viewModel.lastUpdate}",
                      style: TextStyles.textSmRegular(color: AppColors.bluePurple),
                    ),
                  ),
                _spacer(18),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(title, style: TextStyles.textLgMedium),
                  ),
                if (companyName != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(companyName, style: TextStyles.textMdRegular),
                  ),
                _tags(viewModel),
                _offerDescription(viewModel),
                _profileDescription(viewModel),
                _companyDescription(viewModel),
                _subscribeButton(viewModel),
                _spacer(16),
                _applyButton(),
              ],
            ),
          ),
        ));
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
          child: lightBlueTag(label: location, icon: SvgPicture.asset("assets/ic_place.svg")),
        ),
      if (contractType != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: lightBlueTag(label: contractType, icon: SvgPicture.asset("assets/ic_contract.svg")),
        ),
      if (salary != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: lightBlueTag(label: salary, icon: SvgPicture.asset("assets/ic_salary.svg")),
        ),
      if (duration != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: lightBlueTag(label: duration, icon: SvgPicture.asset("assets/ic_time.svg")),
        ),
    ]);
  }

  Widget _offerDescription(OffreEmploiDetailsPageViewModel viewModel) {
    var offerDescription = viewModel.offerDescription != null ? viewModel.offerDescription! : "";

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _descriptionTitle(title: Strings.offerDetailsTitle, icon: SvgPicture.asset("assets/ic_one_point.svg")),
      _separator(8, 12),
      Text(offerDescription, style: TextStyles.textSmRegular()),
      _spacer(30),
    ]);
  }

  Widget _profileDescription(OffreEmploiDetailsPageViewModel viewModel) {
    var experience = viewModel.experience != null ? viewModel.experience! : "";

    Widget? skills = _isDisplaySkillsBlock(skills: viewModel.skills);
    Widget? softSkills = _isDisplaySoftSkillsBlock(softSkills: viewModel.softSkills);
    Widget? educations = _isDisplayEducationsBlock(educations: viewModel.educations);
    Widget? languages = _isDisplayLanguagesBlock(languages: viewModel.languages);
    Widget? driverLicences = _isDisplayDriverLicencesBlock(driverLicences: viewModel.driverLicences);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.profileTitle, icon: SvgPicture.asset("assets/ic_two_points.svg")),
        _separator(8, 20),
        Text(Strings.experienceTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        _experience(xp: experience),
        _separator(20, 20),
        if (skills != null) skills,
        if (softSkills != null) softSkills,
        if (educations != null) educations,
        if (languages != null) languages,
        if (driverLicences != null) driverLicences,
      ],
    );
  }

  Widget _companyDescription(OffreEmploiDetailsPageViewModel viewModel) {
    Widget? companyDescription =
        _isDisplayTextBlock(title: Strings.companyDescriptionTitle, content: viewModel.companyDescription);
    Widget? adaptationTag =
        _isDisplayBlueTag(tagTitle: Strings.companyAdaptedTitle, tagValue: viewModel.companyAdapted);
    Widget? accessibilityTag =
        _isDisplayBlueTag(tagTitle: Strings.companyAccessibilityTitle, tagValue: viewModel.companyAccessibility);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.companyTitle, icon: SvgPicture.asset("assets/ic_three_points.svg")),
        _separator(8, 30),
        Text(viewModel.companyName!, style: TextStyles.textMdMedium),
        if (adaptationTag != null) adaptationTag,
        if (accessibilityTag != null) accessibilityTag,
        _spacer(20),
        if (companyDescription != null) companyDescription,
      ],
    );
  }

  Widget _subscribeButton(OffreEmploiDetailsPageViewModel viewModel) {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      actionButtonWithIcon(label: Strings.subscribeButtonTitle, onPressed: () {}, icon: 'ic_send_mail.svg'),
    ]);
  }

  Widget _applyButton() {
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      actionButton(onPressed: () => null, label: Strings.applyButtonTitle),
    ]);
  }

  Widget _spacer(double _height) {
    return SizedBox(height: _height);
  }

  Widget _separator(double spacerBefore, double spacerAfter) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: spacerBefore),
      Container(height: 1, color: AppColors.borderGrey),
      SizedBox(height: spacerAfter),
    ]);
  }

  Container _descriptionTitle({required String title, SvgPicture? icon}) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: icon,
                ),
              Flexible(
                child: Text(
                  title,
                  style: TextStyles.textLgMedium,
                ),
              ),
            ],
          )),
    );
  }

  Container _experience({required String xp}) {
    return Container(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  "· $xp",
                  style: TextStyles.textSmRegular(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SvgPicture.asset("assets/ic_info.svg"),
              ),
            ],
          )),
    );
  }

  Widget? _isDisplayTextBlock({required String title, required String? content}) {
    return content != null
        ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
            _spacer(12),
            Text(content, style: TextStyles.textSmRegular()),
            _separator(12, 20),
          ])
        : null;
  }

  Widget? _isDisplaySkillsBlock({required List<Skill>? skills}) {
    if (skills == null || skills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.skillsTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        for (final skill in skills)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("· ${skill.description}", style: TextStyles.textSmRegular()),
          ),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplaySoftSkillsBlock({required List<String>? softSkills}) {
    if (softSkills == null || softSkills.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.softSkillsTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        for (final soft in softSkills)
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("· $soft", style: TextStyles.textSmRegular()),
          ),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayEducationsBlock({required List<EducationViewModel>? educations}) {
    if (educations == null || educations.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.educationTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        for (final education in educations)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("· $education", style: TextStyles.textSmRegular()),
          ),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayLanguagesBlock({required List<Language>? languages}) {
    if (languages == null || languages.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.languageTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        for (final language in languages)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("· ${language.type}", style: TextStyles.textSmRegular()),
          ),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayDriverLicencesBlock({required List<DriverLicence>? driverLicences}) {
    if (driverLicences == null || driverLicences.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.driverLicenceTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        for (final licence in driverLicences)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("· ${licence.category}", style: TextStyles.textSmRegular()),
          ),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayBlueTag({required String tagTitle, required bool? tagValue}) {
    if (tagValue == false) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _spacer(12),
        lightBlueTag(label: tagTitle),
      ],
    );
  }
}
