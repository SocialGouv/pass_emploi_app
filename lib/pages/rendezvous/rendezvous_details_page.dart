import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/pages/chat/chat_partage_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsPage extends StatefulWidget {
  final String _rendezvousId;
  final RendezvousStateSource _source;
  final RendezvousDetailsViewModel Function(Store<AppState>) _converter;
  static final _platform = PlatformUtils.getPlatform;

  RendezvousDetailsPage._(this._rendezvousId, this._source, this._converter) : super();

  static MaterialPageRoute<void> materialPageRoute(RendezvousStateSource source, String rendezvousId) {
    return MaterialPageRoute(
      builder: (context) {
        return RendezvousDetailsPage._(
          rendezvousId,
          source,
          (store) => RendezvousDetailsViewModel.create(
            store: store,
            source: source,
            rdvId: rendezvousId,
            platform: _platform,
          ),
        );
      },
    );
  }

  @override
  State<RendezvousDetailsPage> createState() => _RendezvousDetailsPageState();
}

class _RendezvousDetailsPageState extends State<RendezvousDetailsPage> {
  bool _hasBeenTracked = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousDetailsViewModel>(
      onInit: _onInit,
      converter: widget._converter,
      builder: _scaffold,
      onDispose: (store) {
        widget._source == RendezvousStateSource.noSource ? store.dispatch(RendezvousDetailsResetAction()) : {};
        widget._source == RendezvousStateSource.sessionMiloDetails
            ? store.dispatch(SessionMiloDetailsResetAction())
            : {};
      },
      distinct: true,
    );
  }

  void _onInit(Store<AppState> store) {
    if (widget._source == RendezvousStateSource.sessionMiloDetails) {
      store.dispatch(SessionMiloDetailsRequestAction(widget._rendezvousId));
    } else if (widget._source == RendezvousStateSource.noSource) {
      store.dispatch(RendezvousDetailsRequestAction(widget._rendezvousId));
    }
  }

  Widget _scaffold(BuildContext context, RendezvousDetailsViewModel viewModel) {
    _trackPageOnRendezvousRetrievalFromState(viewModel);
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: viewModel.navbarTitle, backgroundColor: backgroundColor),
      body: _body(context, viewModel),
    );
  }

  Widget _body(BuildContext context, RendezvousDetailsViewModel viewModel) {
    return switch (viewModel.displayState) {
      DisplayState.CONTENT => _content(context, viewModel),
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      _ => Center(child: Retry(Strings.rendezVousDetailsError, () => viewModel.onRetry()))
    };
  }

  Widget _content(BuildContext context, RendezvousDetailsViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.withDateDerniereMiseAJour != null) ...[
              NotUpToDateMessage(message: viewModel.withDateDerniereMiseAJour!),
              SizedBox(height: Margins.spacing_base),
            ],
            if (viewModel.isInscrit) ...[
              _InscritTag(),
              SizedBox(height: Margins.spacing_base),
            ],
            JobTag(
              label: viewModel.tag,
              backgroundColor: viewModel.greenTag ? AppColors.accent3Lighten : AppColors.accent2Lighten,
            ),
            SizedBox(height: Margins.spacing_base),
            _Header(viewModel),
            if (viewModel.withModalityPart) _Modality(viewModel),
            if (viewModel.withDescriptionPart) _DescriptionPart(viewModel),
            SepLine(Margins.spacing_m, Margins.spacing_m),
            if (viewModel.withAnimateur != null) ...[
              _AnimateurPart(viewModel.withAnimateur!),
              SepLine(Margins.spacing_m, Margins.spacing_m),
            ],
            _ConseillerPart(viewModel),
            if (viewModel.withIfAbsentPart) _InformIfAbsent(),
            if (viewModel.shareToConseillerSource != null)
              _Share(
                source: viewModel.shareToConseillerSource!,
                buttonTitle: viewModel.shareToConseillerButtonTitle,
              ),
          ],
        ),
      ),
    );
  }

  void _trackPageOnRendezvousRetrievalFromState(RendezvousDetailsViewModel viewModel) {
    if (!_hasBeenTracked && viewModel.trackingPageName != null) {
      PassEmploiMatomoTracker.instance.trackScreen(viewModel.trackingPageName!);
      _hasBeenTracked = true;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.viewModel);

  final RendezvousDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.isAnnule) _Annule(),
        if (viewModel.title != null) Text(viewModel.title!, style: TextStyles.textLBold()),
        SizedBox(height: Margins.spacing_m),
        Row(
          children: [
            Icon(AppIcons.today_rounded, color: AppColors.grey800),
            SizedBox(width: Margins.spacing_s),
            Text(viewModel.date, style: TextStyles.textBaseBold),
            Expanded(child: SizedBox()),
            Icon(AppIcons.schedule_rounded, color: AppColors.grey800),
            SizedBox(width: Margins.spacing_s),
            Text(viewModel.hourAndDuration, style: TextStyles.textBaseBold),
          ],
        ),
      ],
    );
  }
}

class _Modality extends StatelessWidget {
  const _Modality(this.viewModel);

  final RendezvousDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SepLine(Margins.spacing_m, Margins.spacing_m),
        if (viewModel.modality != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_xs),
            child: Text(viewModel.modality!, style: TextStyles.textBaseBold),
          ),
        if (viewModel.conseiller != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s, bottom: Margins.spacing_xs),
            child: Row(
              children: [
                Text(Strings.withConseiller, style: TextStyles.textBaseRegular),
                SizedBox(width: Margins.spacing_xs),
                Text(viewModel.conseiller!, style: TextStyles.textBaseBold),
              ],
            ),
          ),
        if (viewModel.createur != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: _Createur(viewModel.createur!),
          ),
        if (_withInactiveVisioButton())
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryActionButton(label: Strings.seeVisio),
              ],
            ),
          ),
        if (_withActiveVisioButton())
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryActionButton(
                  label: Strings.seeVisio,
                  onPressed: () => launchExternalUrl(viewModel.visioRedirectUrl!),
                ),
              ],
            ),
          ),
        if (viewModel.organism != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_m),
            child: Text(viewModel.organism!, style: TextStyles.textMBold),
          ),
        if (viewModel.address != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: Margins.spacing_xs),
                  child: Icon(AppIcons.place_outlined, color: AppColors.grey800),
                ),
                SizedBox(width: Margins.spacing_s),
                Expanded(child: Text(viewModel.address!, style: TextStyles.textBaseRegular)),
              ],
            ),
          ),
        if (viewModel.addressRedirectUri != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_m),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: SecondaryButton(
                label: Strings.seeItinerary,
                onPressed: () => launchExternalUrl(viewModel.addressRedirectUri!.toString()),
              ),
            ),
          ),
        if (viewModel.phone != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_m),
            child: Text(viewModel.phone!, style: TextStyles.textBaseRegular),
          ),
      ],
    );
  }

  bool _withActiveVisioButton() => viewModel.visioButtonState == VisioButtonState.ACTIVE;

  bool _withInactiveVisioButton() => viewModel.visioButtonState == VisioButtonState.INACTIVE;
}

class _DescriptionPart extends StatelessWidget {
  const _DescriptionPart(this.viewModel);

  final RendezvousDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SepLine(Margins.spacing_m, Margins.spacing_m),
        if (viewModel.theme != null) Text(viewModel.theme!, style: TextStyles.textBaseBold),
        if (viewModel.description != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: TextWithClickableLinks(viewModel.description!, style: TextStyles.textBaseRegular),
          ),
      ],
    );
  }
}

class _AnimateurPart extends StatelessWidget {
  final String withAnimateur;

  const _AnimateurPart(this.withAnimateur);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.withAnimateurTitle, style: TextStyles.textBaseBold),
        Padding(
          padding: const EdgeInsets.only(top: Margins.spacing_s),
          child: TextWithClickableLinks(withAnimateur, style: TextStyles.textBaseRegular),
        ),
      ],
    );
  }
}

class _ConseillerPart extends StatelessWidget {
  final RendezvousDetailsViewModel viewModel;

  const _ConseillerPart(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.withConseillerPresencePart)
          Text(
            viewModel.conseillerPresenceLabel,
            style: TextStyles.textBaseBoldWithColor(viewModel.conseillerPresenceColor),
          ),
        if (_withSepLine()) SepLine(Margins.spacing_m, Margins.spacing_m),
        if (viewModel.commentTitle != null) Text(viewModel.commentTitle!, style: TextStyles.textBaseBold),
        if (viewModel.comment != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: TextWithClickableLinks(viewModel.comment!, style: TextStyles.textBaseRegular),
          ),
        if (_withEndSepLine()) SepLine(Margins.spacing_m, Margins.spacing_m),
      ],
    );
  }

  bool _withSepLine() => viewModel.withConseillerPresencePart && viewModel.comment != null;

  bool _withEndSepLine() =>
      viewModel.withConseillerPresencePart || viewModel.commentTitle != null || viewModel.comment != null;
}

class _InformIfAbsent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.cannotGoToRendezvous, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.shouldInformConseiller, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class _Annule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: AppColors.warningLighten,
          border: Border.all(color: AppColors.warning),
        ),
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
        child: Text(
          Strings.rendezvousDetailsAnnule,
          style: TextStyles.textSRegularWithColor(AppColors.warning),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Createur extends StatelessWidget {
  final String label;

  const _Createur(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Margins.spacing_s),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(Margins.spacing_xs),
              child: Icon(AppIcons.info_rounded, color: AppColors.primary),
            ),
            SizedBox(width: Margins.spacing_s),
            Flexible(child: Text(label, style: TextStyles.textBaseRegularWithColor(AppColors.primary))),
          ],
        ),
      ),
    );
  }
}

class _Share extends StatelessWidget {
  final String? buttonTitle;
  final ChatPartageSource source;

  _Share({required this.buttonTitle, required this.source});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryActionButton(
            label: buttonTitle ?? Strings.shareToConseiller,
            onPressed: () => ChatPartageBottomSheet.show(context, source),
          ),
        ],
      ),
    );
  }
}

class _InscritTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.radius_l),
        border: Border.all(color: AppColors.accent1),
      ),
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.today_rounded, color: AppColors.accent1),
          SizedBox(width: Margins.spacing_s),
          Text(Strings.eventVousEtesDejaInscrit, style: TextStyles.textSRegularWithColor(AppColors.accent1)),
        ],
      ),
    );
  }
}
