import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CalendarCard extends StatelessWidget {
  final String tag;
  final String date;
  final String? titre;
  final String sousTitre;
  final String texteLien;
  final VoidCallback onTap;

  const CalendarCard({
    Key? key,
    required this.tag,
    required this.date,
    this.titre,
    required this.sousTitre,
    required this.texteLien,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Margins.spacing_base),
        boxShadow: [Shadows.boxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Margins.spacing_base),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tag(tag: tag),
                  _Date(date: date),
                  if (titre != null) _Titre(titre: titre),
                  _SousTitre(sousTitre: sousTitre),
                  _Link(texteLien: texteLien),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({Key? key, required this.tag}) : super(key: key);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: AppColors.primaryLighten,
        border: Border.all(color: AppColors.primary),
      ),
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
      child: Text(tag, style: TextStyles.textSRegularWithColor(AppColors.primary)),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({Key? key, required this.date}) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SvgPicture.asset(Drawables.icClock, color: AppColors.primary),
          SizedBox(width: Margins.spacing_s),
          Text(date, style: TextStyles.textSRegularWithColor(AppColors.primary)),
        ],
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre({
    Key? key,
    required this.titre,
  }) : super(key: key);

  final String? titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(titre!, style: TextStyles.textBaseBold),
    );
  }
}

class _SousTitre extends StatelessWidget {
  const _SousTitre({Key? key, required this.sousTitre}) : super(key: key);

  final String sousTitre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(sousTitre, style: TextStyles.textSRegular(color: AppColors.grey800)),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({Key? key, required this.texteLien}) : super(key: key);

  final String texteLien;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          Text(texteLien, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(width: Margins.spacing_s),
          SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
        ],
      ),
    );
  }
}
