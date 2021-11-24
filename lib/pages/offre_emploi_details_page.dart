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
    var companyName = viewModel.companyName != null ? viewModel.companyName! : "";

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
                    child: Text("Actualisée le ${viewModel.lastUpdate}",
                        style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
                  ),
                _spacer(18),
                Text(viewModel.title != null ? viewModel.title as String : "", style: TextStyles.textLgMedium),
                _spacer(20),
                Text(companyName, style: TextStyles.textMdRegular),
                _spacer(12),
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
    var location = viewModel.location != null ? viewModel.location! : "";
    var contractType = viewModel.contractType != null ? viewModel.contractType! : "";
    var salary = viewModel.salary != null ? viewModel.salary! : "";
    var duration = viewModel.location != null ? viewModel.duration! : "";

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      lightBlueTag(label: location, icon: SvgPicture.asset("assets/ic_place.svg")),
      _spacer(12),
      lightBlueTag(label: contractType, icon: SvgPicture.asset("assets/ic_contract.svg")),
      _spacer(12),
      lightBlueTag(label: salary, icon: SvgPicture.asset("assets/ic_salary.svg")),
      _spacer(12),
      lightBlueTag(label: duration, icon: SvgPicture.asset("assets/ic_time.svg")),
      _spacer(30),
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

    Widget? skills = _isDisplaySillsBlock(skills: viewModel.skills);
    Widget? softSkills = _isDisplaySoftSillsBlock(softSkills: viewModel.softSkills);
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
                  xp,
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

  Widget? _isDisplaySillsBlock({required List<Skill?>? skills}) {
    if (skills == null) return null;
    return skills.length != 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.skillsTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
              _spacer(12),
              Text(skills[0]!.description!, style: TextStyles.textSmRegular()),
              // ListView.builder(
              // itemCount: skills!.length,
              // itemBuilder: (context, index) {
              // return ListTile(
              // title: Text(skills[index]!.description!, style: TextStyles.textSmRegular()),
              // );
              //   },
              // ),
              _separator(20, 20),
            ],
          )
        : null;
  }

  Widget? _isDisplaySoftSillsBlock({required List<String>? softSkills}) {
    if (softSkills == null) return null;
    return softSkills.length != 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Strings.softSkillsTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
              _spacer(12),
              for(var soft in softSkills) Text(soft, style: TextStyles.textSmRegular()),
              _separator(20, 20),
            ],
          )
        : null;
  }

  Widget? _isDisplayEducationsBlock({required List<Education?>? educations}) {
    if (educations == null || educations.length == 0) return null;
    var educationLvl = educations[0]!.level != null ? educations[0]!.level! : "";
    var educationField = educations[0]!.field != null ? educations[0]!.field! : "";
    var education = educationLvl + educationField;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.educationTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        Text(education, style: TextStyles.textSmRegular()),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayLanguagesBlock({required List<Language?>? languages}) {
    if (languages == null || languages.length == 0) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.languageTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        Text(languages[0]!.type!, style: TextStyles.textSmRegular()),
        _separator(20, 20),
      ],
    );
  }

  Widget? _isDisplayDriverLicencesBlock({required List<DriverLicence?>? driverLicences}) {
    if (driverLicences == null || driverLicences.length == 0) return null;
    var driverLicence = driverLicences[0]!.category == null ? "" : driverLicences[0]!.category!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.driverLicenceTitle, style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        Text(driverLicence, style: TextStyles.textSmRegular()),
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
