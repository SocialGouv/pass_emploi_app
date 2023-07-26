import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';
import 'package:pass_emploi_app/widgets/tags/status_tag.dart';
import 'package:redux/redux.dart';

class RendezvousCard extends StatelessWidget {
  final RendezvousCardViewModel Function(Store<AppState>) converter;
  final VoidCallback onTap;
  final bool simpleCard;

  const RendezvousCard({
    Key? key,
    required this.converter,
    required this.onTap,
    this.simpleCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousCardViewModel>(
      converter: converter,
      builder: (context, viewModel) => _Content(viewModel, onTap, simpleCard),
    );
  }
}

class _Content extends StatelessWidget {
  final RendezvousCardViewModel viewModel;
  final VoidCallback onTap;
  final bool simpleCard;

  const _Content(this.viewModel, this.onTap, this.simpleCard, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: Margins.spacing_s,
                  runSpacing: Margins.spacing_s,
                  children: [
                    if (viewModel.isAnnule && simpleCard == false) _Annule(),
                    JobTag(
                      label: viewModel.tag,
                      backgroundColor: viewModel.greenTag ? AppColors.accent3Lighten : AppColors.accent2Lighten,
                    ),
                  ],
                ),
              ),
              SizedBox(width: Margins.spacing_base),
              if (viewModel.isInscrit) _InscritTag(),
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          if (viewModel.title != null && simpleCard == false) ...[
            _Titre(viewModel.title!),
            SizedBox(height: Margins.spacing_base)
          ],
          if (viewModel.subtitle != null && simpleCard == false) ...[
            _SousTitre(viewModel.subtitle!),
            SizedBox(height: Margins.spacing_base)
          ],
          _Date(viewModel.date),
          SizedBox(height: Margins.spacing_base),
          PressedTip(Strings.voirLeDetail),
        ],
      ),
    );
  }
}

class _Annule extends StatelessWidget {
  const _Annule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatutTag.icon(
      icon: AppIcons.close_rounded,
      backgroundColor: AppColors.accent2Lighten,
      textColor: AppColors.accent2,
      title: Strings.rendezvousCardAnnule,
    );
  }
}

class _Date extends StatelessWidget {
  const _Date(this.date, {Key? key}) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.today_outlined, color: AppColors.primary, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_xs),
        Text(date, style: TextStyles.textSMedium(color: AppColors.contentColor)),
      ],
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.titre, {Key? key}) : super(key: key);

  final String titre;

  @override
  Widget build(BuildContext context) {
    return Text(titre, style: TextStyles.textMBold);
  }
}

class _SousTitre extends StatelessWidget {
  const _SousTitre(this.sousTitre, {Key? key}) : super(key: key);

  final String sousTitre;

  @override
  Widget build(BuildContext context) {
    return Text(sousTitre, style: TextStyles.textSRegular(color: AppColors.grey800));
  }
}

extension RendezvousCardFromId on String {
  Widget rendezvousCard({
    required BuildContext context,
    required RendezvousStateSource stateSource,
    required EventType trackedEvent,
    bool simpleCard = false,
  }) {
    return RendezvousCard(
      converter: (store) => RendezvousCardViewModel.create(store, stateSource, this),
      simpleCard: simpleCard,
      onTap: () {
        context.trackEvent(trackedEvent);
        Navigator.push(
          context,
          RendezvousDetailsPage.materialPageRoute(_stateSource(stateSource), this),
        );
      },
    );
  }
}

RendezvousStateSource _stateSource(RendezvousStateSource stateSource) {
  if (stateSource == RendezvousStateSource.eventListSessionsMilo) {
    return RendezvousStateSource.sessionMiloDetails;
  }
  return stateSource;
}

class _InscritTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(AppIcons.today_rounded, color: AppColors.accent1),
      ),
    );
  }
}
