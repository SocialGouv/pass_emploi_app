import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/platform.dart';
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
      builder: (context, viewModel) {
        MatomoTracker.trackScreenWithName(viewModel.trackingPageName, "");
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: passEmploiAppBar(label: Strings.myRendezVous, withBackButton: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(viewModel),
                  SepLine(Margins.spacing_m, Margins.spacing_m),
                  _Modality(viewModel),
                  SepLine(Margins.spacing_m, Margins.spacing_m),
                  _ConseillerPart(viewModel),
                  SepLine(Margins.spacing_m, Margins.spacing_m),
                  _InformIfAbsent(),
                ],
              ),
            ),
          ),
        );
      },
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
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_xs),
          child: Text(viewModel.modality, style: TextStyles.textBaseBold),
        ),
        if (viewModel.organism != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_m),
            child: Text(viewModel.organism!, style: TextStyles.textMBold),
          ),
        if (viewModel.address != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_xs),
            child: Text(viewModel.address!, style: TextStyles.textBaseRegular),
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
        Text(
          viewModel.conseillerPresenceLabel,
          style: TextStyles.textBaseBoldWithColor(viewModel.conseillerPresenceColor),
        ),
        if (viewModel.comment != null) SepLine(Margins.spacing_m, Margins.spacing_m),
        if (viewModel.commentTitle != null) Text(viewModel.commentTitle!, style: TextStyles.textBaseBold),
        if (viewModel.comment != null)
          Padding(
            padding: const EdgeInsets.only(top: Margins.spacing_s),
            child: TextWithClickableLinks(viewModel.comment!, style: TextStyles.textBaseRegular),
          ),
      ],
    );
  }
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
