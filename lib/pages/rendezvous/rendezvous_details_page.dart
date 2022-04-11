import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/text_with_clickable_links.dart';
import 'package:url_launcher/url_launcher.dart';

class RendezvousDetailsPage extends StatelessWidget {
  final String rendezvousId;

  RendezvousDetailsPage._(this.rendezvousId) : super();

  static MaterialPageRoute<void> materialPageRoute(String rendezvousId) {
    return MaterialPageRoute(builder: (context) => RendezvousDetailsPage._(rendezvousId));
  }

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isIOS ? Platform.IOS : Platform.ANDROID;
    return StoreConnector<AppState, RendezvousDetailsViewModel>(
      converter: (store) => RendezvousDetailsViewModel.create(store, rendezvousId, platform),
      builder: _builder,
    );
  }

  Widget _builder(BuildContext context, RendezvousDetailsViewModel viewModel) {
    MatomoTracker.trackScreenWithName(viewModel.trackingPageName, "");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.myRendezVous, context: context, withBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(viewModel),
              if (viewModel.withModalityPart) _Modality(viewModel),
              if (viewModel.withDescriptionPart) _DescriptionPart(viewModel),
              SepLine(Margins.spacing_m, Margins.spacing_m),
              _ConseillerPart(viewModel),
              _InformIfAbsent(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.viewModel, {Key? key}) : super(key: key);

  final RendezvousDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.isAnnule) _Annule(),
        Text(viewModel.title, style: TextStyles.textLBold()),
        SizedBox(height: Margins.spacing_m),
        Row(
          children: [
            SvgPicture.asset(Drawables.icCalendar),
            SizedBox(width: Margins.spacing_s),
            Text(viewModel.date, style: TextStyles.textBaseBold),
            Expanded(child: SizedBox()),
            SvgPicture.asset(Drawables.icClock),
            SizedBox(width: Margins.spacing_s),
            Text(viewModel.hourAndDuration, style: TextStyles.textBaseBold),
          ],
        ),
      ],
    );
  }
}

class _Modality extends StatelessWidget {
  const _Modality(this.viewModel, {Key? key}) : super(key: key);

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
                  onPressed: () => launch(viewModel.visioRedirectUrl!),
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
                  child: SvgPicture.asset(Drawables.icPlace),
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
                onPressed: () => launch(viewModel.addressRedirectUri!.toString()),
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
  const _DescriptionPart(this.viewModel, {Key? key}) : super(key: key);

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

class _ConseillerPart extends StatelessWidget {
  const _ConseillerPart(this.viewModel, {Key? key}) : super(key: key);

  final RendezvousDetailsViewModel viewModel;

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
  const _InformIfAbsent({Key? key}) : super(key: key);

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
  const _Annule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_base),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: AppColors.warningLight,
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
