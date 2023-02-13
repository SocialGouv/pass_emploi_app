import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/solution_type.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/tags/solution_tag.dart';

class FavoriCard<T> extends StatelessWidget {
  final SolutionType solutionType;
  final Widget? specialAction;
  final String title;
  final String? company;
  final String? place;
  final String? date;
  final String bottomTip;
  final void Function()? onTap;
  final List<Widget> dataTags;

  FavoriCard({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    this.dataTags = const [],
    required this.bottomTip,
    required this.solutionType,
    this.specialAction,
  });

  FavoriCard.likable({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    this.dataTags = const [],
    required this.bottomTip,
    required this.solutionType,
    required String id,
    required OffrePage from,
  }) : specialAction = FavoriHeart<T>(
          offreId: id,
          withBorder: false,
          from: from,
        );

  FavoriCard.deletable({
    super.key,
    this.onTap,
    required this.title,
    this.company,
    required this.place,
    this.date,
    this.dataTags = const [],
    required this.bottomTip,
    required this.solutionType,
    required void Function() onDelete,
  }) : specialAction = IconButton(
          icon: Icon(AppIcons.delete_rounded),
          onPressed: onDelete,
          color: AppColors.primary,
        );

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              solutionType.toJobTag(),
              SizedBox.square(
                  dimension: Dimens.icon_size_m,
                  child: OverflowBox(
                    // to avoid extra padding
                    maxHeight: 40,
                    maxWidth: 40,
                    child: specialAction ?? Container(),
                  )),
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          _Title(title),
          SizedBox(height: Margins.spacing_base),
          if (company != null) ...[
            _Company(company!),
            SizedBox(height: Margins.spacing_xs),
          ],
          if (place != null) ...[
            _Place(place!),
            SizedBox(height: Margins.spacing_base),
          ],
          if (date != null) ...[
            _Date(date!),
            SizedBox(height: Margins.spacing_base),
          ],
          if (dataTags.isNotEmpty) ...[
            Wrap(spacing: Margins.spacing_base, runSpacing: Margins.spacing_base, children: dataTags),
            SizedBox(height: Margins.spacing_base),
          ],
          _PressedTip(bottomTip),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  const _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyles.textMBold);
  }
}

class _Company extends StatelessWidget {
  final String company;
  const _Company(this.company);

  @override
  Widget build(BuildContext context) {
    return Text(company, style: TextStyles.textSBold);
  }
}

class _Place extends StatelessWidget {
  final String place;
  const _Place(this.place);

  @override
  Widget build(BuildContext context) {
    const color = AppColors.grey800;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.location_on_rounded, color: color, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_s),
        Text(place, style: TextStyles.textSRegular(color: color)),
      ],
    );
  }
}

class _Date extends StatelessWidget {
  final String date;
  const _Date(this.date);

  @override
  Widget build(BuildContext context) {
    return Text(date, style: TextStyles.textSRegular(color: Colors.black));
  }
}

class _PressedTip extends StatelessWidget {
  final String tip;
  const _PressedTip(this.tip);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            tip,
            style: TextStyles.textSMedium(color: Colors.black),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: Margins.spacing_xs),
        Icon(AppIcons.chevron_right_rounded, color: Colors.black, size: Dimens.icon_size_m),
      ],
    );
  }
}
