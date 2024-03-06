import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/chat/chat_partage_bottom_sheet.dart';
import 'package:pass_emploi_app/presentation/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi/evenement_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/buttons/share_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';

class EvenementEmploiDetailsPage extends StatelessWidget {
  final String eventId;

  EvenementEmploiDetailsPage({required this.eventId});

  static MaterialPageRoute<void> materialPageRoute(String eventId) {
    return MaterialPageRoute(
      builder: (context) {
        return EvenementEmploiDetailsPage(eventId: eventId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    return Tracker(
      tracking: AnalyticsScreenNames.evenementEmploiDetails,
      child: StoreConnector<AppState, EvenementEmploiDetailsPageViewModel>(
        onInit: (store) => store.dispatch(EvenementEmploiDetailsRequestAction(eventId)),
        converter: (store) => EvenementEmploiDetailsPageViewModel.create(store),
        builder: (context, vm) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: SecondaryAppBar(title: Strings.eventEmploiDetailsAppBarTitle, backgroundColor: backgroundColor),
            body: _Body(viewModel: vm, eventId: eventId),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;
  final String eventId;

  const _Body({required this.viewModel, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.LOADING => Center(child: CircularProgressIndicator()),
      DisplayState.CONTENT => _Content(viewModel: viewModel),
      DisplayState.EMPTY || DisplayState.FAILURE => _Retry(viewModel: viewModel, eventId: eventId),
    };
  }
}

class _Content extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;

  _Content({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(viewModel: viewModel),
              SepLine(Margins.spacing_base, Margins.spacing_base),
              if (viewModel.description != null) ...[
                _Details(description: viewModel.description!),
                SepLine(Margins.spacing_base, Margins.spacing_base),
              ],
              _FooterButtons(viewModel: viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;

  _Header({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.tag != null) ...[
          JobTag(
            label: viewModel.tag!,
            backgroundColor: AppColors.additional5Lighten,
          ),
          SizedBox(height: Margins.spacing_s),
        ],
        Text(viewModel.titre, style: TextStyles.textLBold()),
        SizedBox(height: Margins.spacing_base),
        Row(
          children: [
            Icon(AppIcons.today_outlined, color: AppColors.primary, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs),
            Text(viewModel.date, style: TextStyles.textBaseBold),
            Expanded(child: SizedBox.shrink()),
            Icon(AppIcons.schedule, color: AppColors.primary, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs),
            Text(viewModel.heure, style: TextStyles.textBaseBold),
          ],
        ),
        SizedBox(height: Margins.spacing_s),
        Row(
          children: [
            Icon(AppIcons.place_outlined, color: AppColors.primary, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs),
            Text(viewModel.lieu, style: TextStyles.textBaseRegular),
          ],
        ),
        SizedBox(height: Margins.spacing_base),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: Strings.eventEmploiDetailsPartagerConseiller,
            onPressed: () => partagerConseiller(context),
          ),
        ),
      ],
    );
  }

  void partagerConseiller(BuildContext context) {
    context.trackEvent(EventType.EVENEMENT_EXTERNE_PARTAGE_CONSEILLER);
    ChatPartageBottomSheet.show(context, ChatPartageEvenementEmploiSource());
  }
}

class _Details extends StatelessWidget {
  final String description;

  _Details({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text("•", style: TextStyles.textMBoldWithColor(color: AppColors.primary)),
            SizedBox(width: Margins.spacing_s),
            Text(Strings.evenementEmploiDetails, style: TextStyles.textMBoldWithColor(color: AppColors.grey800)),
          ],
        ),
        SizedBox(height: Margins.spacing_m),
        Text(description, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class _FooterButtons extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;

  _FooterButtons({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (viewModel.url != null)
          Expanded(
            child: PrimaryActionButton(
              icon: AppIcons.open_in_new_rounded,
              iconSize: Dimens.icon_size_base,
              label: Strings.eventEmploiDetailsInscription,
              onPressed: () => _openInscriptionUrl(context),
            ),
          ),
        // SizedBox(width: Margins.spacing_base),
        // FavoriHeart<EvenementEmploiDetails>(
        //   offreId: "offreId",
        //   withBorder: true,
        //   from: OffrePage.emploiDetails,
        //   onFavoriRemoved: null,
        // ),
        if (viewModel.url != null) ...[
          SizedBox(width: Margins.spacing_base),
          ShareButton(
            viewModel.url!,
            viewModel.titre,
            () => context.trackEvent(EventType.EVENEMENT_EXTERNE_PARTAGE),
          ),
        ],
      ],
    );
  }

  void _openInscriptionUrl(BuildContext context) {
    if (viewModel.url == null) return;
    context.trackEvent(EventType.EVENEMENT_EXTERNE_INSCRIPTION);
    PassEmploiMatomoTracker.instance.trackEvent(
      eventCategory: AnalyticsEventNames.evenementEmploiDetailsCategory,
      action: AnalyticsEventNames.evenementEmploiDetailsInscriptionAction,
    );
    launchExternalUrl(viewModel.url!);
  }
}

class _Retry extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;
  final String eventId;

  const _Retry({required this.viewModel, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Retry(Strings.miscellaneousErrorRetry, () => viewModel.retry(eventId)),
      ),
    );
  }
}
