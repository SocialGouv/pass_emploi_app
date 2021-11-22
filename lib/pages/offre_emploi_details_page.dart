import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/actionButtons.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/tags.dart';

class OffreEmploiDetailsPage extends StatelessWidget {
  OffreEmploiDetailsPage._(this._offer) : super();

  final OffreEmploiItemViewModel _offer;

  static MaterialPageRoute materialPageRoute(OffreEmploiItemViewModel offer) {
    return MaterialPageRoute(
        builder: (context) => OffreEmploiDetailsPage._(offer), settings: AnalyticsRouteSettings.detailsOffreEmploi());
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }

  Widget _scaffold(BuildContext context){
    return Scaffold(
        appBar: DefaultAppBar(title: Text(Strings.offerDetails, style: TextStyles.h3Semi)),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Offre n°${_offer.id}", style: TextStyles.textSmRegular()),
                _spacer(4),
                Text("Actualisée le 29 octobre 2021", style: TextStyles.textSmRegular(color: AppColors.bluePurple)),
                _spacer(18),
                Text(_offer.title, style: TextStyles.textLgMedium),
                _spacer(20),
                Text(_offer.companyName!, style: TextStyles.textMdRegular),
                _spacer(12),
                _tags(),
                _offerDescription(),
                _profileDescription(),
                _companyDescription(),
                _subscribeButton(),
                _spacer(16),
                _applyButton(),
              ],
            ),
      ),
    ));
  }

  Widget _tags() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lightBlueTag(label: _offer.location, icon: SvgPicture.asset("assets/ic_place.svg")),
          _spacer(12),
          lightBlueTag(label: _offer.contractType, icon: SvgPicture.asset("assets/ic_contract.svg")),
          _spacer(12),
          lightBlueTag(label: "Some salary", icon: SvgPicture.asset("assets/ic_salary.svg")),
          _spacer(12),
          lightBlueTag(label: _offer.duration!, icon: SvgPicture.asset("assets/ic_time.svg")),
          _spacer(30),
        ]
    );
  }

  Widget _offerDescription() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _descriptionTitle(title: "Détail de l'offre", icon: SvgPicture.asset("assets/ic_one_point.svg")),
          _separator(8, 12),
          Text("Some détail de l'offre...", style: TextStyles.textSmRegular()),
          _spacer(30),
        ]
    );
  }

  Widget _profileDescription() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _descriptionTitle(title: "Profil souhaité", icon: SvgPicture.asset("assets/ic_two_points.svg")),
          _separator(8, 20),
          Text("Expériences", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(12),
          _experience(xp: "5 ans"),
          _separator(20, 20),
          Text("Savoir et savoir faire", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(12),
          Text("Some skills...", style: TextStyles.textSmRegular()),
          _separator(20, 20),
          Text("Savoir être professionnel", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(20),
          Text("Some skills...", style: TextStyles.textSmRegular()),
          _separator(20, 20),
          Text("Formation", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(20),
          Text("Some education...", style: TextStyles.textSmRegular()),
          _separator(20, 20),
          Text("Langue", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(20),
          Text("Some language...", style: TextStyles.textSmRegular()),
          _separator(20, 20),
          Text("Permis", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
          _spacer(20),
          Text("Some driver's licence...", style: TextStyles.textSmRegular()),
          _spacer(30),
        ],
    );
  }

  Widget _companyDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _descriptionTitle(title: "Entreprise", icon: SvgPicture.asset("assets/ic_three_points.svg")),
        _separator(8, 30),
        Text(_offer.companyName!, style: TextStyles.textMdMedium),
        _spacer(8),
        Text("5 persons", style: TextStyles.textSmRegular()),
        _spacer(8),
        Text("Some tags", style: TextStyles.textSmRegular()),
        _separator(30, 30),
        Text("Détail de l'entreprise", style: TextStyles.textSmMedium(color: AppColors.bluePurple)),
        _spacer(12),
        Text("Some description", style: TextStyles.textSmRegular()),
        _separator(12, 20),
      ],
    );
  }

  Widget _subscribeButton() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          actionButtonWithIcon(
          label: "Recevoir l'offre par mail",
          onPressed: () {  },
          icon: 'ic_send_mail.svg'
          ),
        ]
    );
  }

  Widget _applyButton() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:[
          actionButton(
              onPressed: () => null,
              label: "Je postule"
          ),
        ]
    );
  }

  Widget _spacer(double _height) {
    return SizedBox(height: _height);
  }

  Widget _separator(double spacerBefore, double spacerAfter) {
    return Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: spacerBefore),
          Container(height: 1, color: AppColors.borderGrey),
          SizedBox(height: spacerAfter),
        ]
    );
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
                padding: const EdgeInsets.only(right: 8),
                child: SvgPicture.asset("assets/ic_info.svg"),
              ),
            ],
          )),
    );
  }

}