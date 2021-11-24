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
      builder: (context, viewModel) => _scaffold(_body(context, viewModel)),
    );
  }

  Widget _body(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case OffreEmploiDetailsPageDisplayState.SHOW_DETAILS:
        return _content(context, viewModel);
      case OffreEmploiDetailsPageDisplayState.SHOW_LOADER:
        return _loading();
      case OffreEmploiDetailsPageDisplayState.SHOW_ERROR:
        return _error();
    }
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(appBar: FlatDefaultAppBar(title: Text(Strings.offerDetails, style: TextStyles.h3Semi)), body: body);
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Widget _error() => Center(child: Text(Strings.offerDetailsError));

  Widget _content(BuildContext context, OffreEmploiDetailsPageViewModel viewModel) {
    final id = viewModel.id;
    final title = viewModel.title;
    final companyName = viewModel.companyName;
    final lastUpdate = viewModel.lastUpdate;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Margins.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (id != null) Text(Strings.offreDetailNumber(id), style: TextStyles.textSmRegular()),
            if (lastUpdate != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  Strings.offreDetailNumber(lastUpdate),
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
          ],
        ),
      ),
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
    final offerDescription = viewModel.offerDescription;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _descriptionTitle(title: Strings.offerDetailsTitle, icon: SvgPicture.asset("assets/ic_one_point.svg")),
      _separator(8, 12),
      if (offerDescription != null) Text(offerDescription, style: TextStyles.textSmRegular()),
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
        _descriptionTitle(title: Strings.profileTitle, icon: SvgPicture.asset("assets/ic_two_points.svg")),
        _separator(8, 20),
        Text(Strings.experienceTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        if (experience != null) _experience(xp: experience),
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
    final companyName = viewModel.companyName;
    final companyDescription = viewModel.companyDescription;
    final companyAdapted = viewModel.companyAdapted != null ? viewModel.companyAdapted! : false;
    final companyAccessibility = viewModel.companyAccessibility != null ? viewModel.companyAccessibility! : false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: Strings.companyTitle, icon: SvgPicture.asset("assets/ic_three_points.svg")),
        _separator(8, 30),
        if (companyName != null) Text(companyName, style: TextStyles.textMdMedium),
        if (companyAdapted) _blueTag(tagTitle: Strings.companyAdaptedTitle),
        if (companyAccessibility) _blueTag(tagTitle: Strings.companyAccessibilityTitle),
        _spacer(20),
        if (companyDescription != null) _companyDescriptionBlock(content: companyDescription),
      ],
    );
  }

  Widget _spacer(double _height) => SizedBox(height: _height);

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
            if (icon != null) Padding(padding: const EdgeInsets.only(right: 14), child: icon),
            Flexible(child: Text(title, style: TextStyles.textLgMedium)),
          ],
        ),
      ),
    );
  }

  Widget _experience({required String xp}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text("· $xp", style: TextStyles.textSmRegular())),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SvgPicture.asset("assets/ic_info.svg"),
          ),
        ],
      ),
    );
  }

  Widget _companyDescriptionBlock({required String content}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(Strings.companyDescriptionTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
      _spacer(12),
      Text(content, style: TextStyles.textSmRegular()),
      _separator(12, 20),
    ]);
  }

  Widget? _skillsBlock({required List<Skill>? skills}) {
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

  Widget? _softSkillsBlock({required List<String>? softSkills}) {
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

  Widget? _educationsBlock({required List<EducationViewModel>? educations}) {
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

  Widget? _languagesBlock({required List<Language>? languages}) {
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

  Widget? _driverLicencesBlock({required List<DriverLicence>? driverLicences}) {
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

  Widget _blueTag({required String tagTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _spacer(12),
        lightBlueTag(label: tagTitle),
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
}
