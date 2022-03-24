import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RendezvousCard extends StatelessWidget {
  final String rendezvousId;
  final VoidCallback onTap;

  const RendezvousCard({Key? key, required this.rendezvousId, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousCardViewModel>(
      converter: (store) => RendezvousCardViewModel.create(store, rendezvousId),
      builder: (context, viewModel) => _Container(viewModel, onTap),
    );
  }
}

class _Container extends StatelessWidget {
  const _Container(this.viewModel, this.onTap, {Key? key}) : super(key: key);

  final RendezvousCardViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
                  if (viewModel.isAnnule) _Annule(),
                  _Tag(viewModel.tag),
                  _Date(viewModel.date),
                  if (viewModel.title != null) _Titre(viewModel.title!),
                  if (viewModel.subtitle != null) _SousTitre(viewModel.subtitle!),
                  _Link(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Annule extends StatelessWidget {
  const _Annule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: AppColors.warningLight,
          border: Border.all(color: AppColors.warning),
        ),
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
        child: Text(
          Strings.rendezvousAnnule,
          style: TextStyles.textSRegularWithColor(AppColors.warning),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.tag, {Key? key}) : super(key: key);

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
      child: Text(
        tag,
        style: TextStyles.textSRegularWithColor(AppColors.primary),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date(this.date, {Key? key}) : super(key: key);

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
  const _Titre(this.titre, {Key? key}) : super(key: key);

  final String titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(titre, style: TextStyles.textBaseBold),
    );
  }
}

class _SousTitre extends StatelessWidget {
  const _SousTitre(this.sousTitre, {Key? key}) : super(key: key);

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
  const _Link({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          Text(Strings.linkDetailsRendezVous, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(width: Margins.spacing_s),
          SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
        ],
      ),
    );
  }
}
