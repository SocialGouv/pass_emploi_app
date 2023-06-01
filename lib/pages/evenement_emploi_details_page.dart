import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/evenement_emploi_details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/presentation/evenement_emploi_details_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
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
            body: _Body(viewModel: vm),
          );
        });
  }
}

class _Body extends StatelessWidget {
  final EvenementEmploiDetailsPageViewModel viewModel;

  _Body({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(viewModel: viewModel),
            SepLine(Margins.spacing_base, Margins.spacing_base),
            _Details(viewModel: viewModel),
            SepLine(Margins.spacing_base, Margins.spacing_base),
            _FooterButtons(viewModel: viewModel),
          ],
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
        JobTag(
          label: viewModel.tag!, //TODO:
          backgroundColor: AppColors.additional5Ligten,
        ),
        SizedBox(height: Margins.spacing_s),
        Text(viewModel.titre, style: TextStyles.textLBold()),
        SizedBox(height: Margins.spacing_base),
        Row(
          children: [
            Text(viewModel.date, style: TextStyles.textBaseBold),
            Text(viewModel.heure, style: TextStyles.textBaseBold),
          ],
        ),
        SizedBox(height: Margins.spacing_s),
        Row(
          children: [
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
  final EvenementEmploiDetailsPageViewModel viewModel;

  _Details({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text("Détaillllls", style: TextStyles.textMBoldWithColor(color: AppColors.grey800)),
          ],
        ),
        SizedBox(height: Margins.spacing_m),
        Text(viewModel.description!, style: TextStyles.textBaseRegular), //TODO:
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
        PrimaryActionButton(label: Strings.eventEmploiDetailsInscription),
        SizedBox(width: Margins.spacing_m),
        Text("love"),
        SizedBox(width: Margins.spacing_m),
        Text("share"),
      ],
    );
  }
}
