import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
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
    return StoreConnector<AppState, EvenementEmploiDetailsPageViewModel>(
        onInit: (store) => store.dispatch(EvenementEmploiDetailsRequestAction(eventId)),
        converter: (store) => EvenementEmploiDetailsPageViewModel.create(store),
        builder: (context, vm) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: SecondaryAppBar(title: Strings.eventEmploiDetailsAppBarTitle, backgroundColor: backgroundColor),
            body: _Body(viewModel: vm, eventId: eventId),
          );
        });
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
            backgroundColor: AppColors.additional5Ligten,
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
            Icon(AppIcons.location_on_rounded, color: AppColors.primary, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_xs),
            Text(viewModel.lieu, style: TextStyles.textBaseRegular),
          ],
        ),
        SizedBox(height: Margins.spacing_base),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: Strings.eventEmploiDetailsPartager,
            onPressed: () => {},
          ),
        ),
      ],
    );
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
            Text(Strings.eventDetails, style: TextStyles.textMBoldWithColor(color: AppColors.grey800)),
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
        Expanded(child: PrimaryActionButton(label: Strings.eventEmploiDetailsInscription)),
        SizedBox(width: Margins.spacing_base),
        // FavoriHeart<EvenementEmploiDetails>(
        //   offreId: "offreId",
        //   withBorder: true,
        //   from: OffrePage.emploiDetails,
        //   onFavoriRemoved: null,
        // ),
        // SizedBox(width: Margins.spacing_base),
        // ShareButton(url, title, () => _shareOffer(context)),
        Text("(futur us) + (futur us)")
      ],
    );
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
        child: Retry(Strings.agendaError, () => viewModel.retry(eventId)),
      ),
    );
  }
}
