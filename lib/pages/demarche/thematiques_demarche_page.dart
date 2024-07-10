import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_custom_demarche.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step2_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class ThematiqueDemarchePage extends StatelessWidget {
  const ThematiqueDemarchePage({super.key});

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => ThematiqueDemarchePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.thematiquesDemarche,
      child: StoreConnector<AppState, ThematiqueDemarchePageViewModel>(
        onInit: (store) => store.dispatch(ThematiqueDemarcheRequestAction()),
        converter: (store) => ThematiqueDemarchePageViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold(this.viewModel);
  final ThematiqueDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(title: Strings.demarcheThematiqueTitle),
      body: _Body(viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final ThematiqueDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.FAILURE => _ErrorMessage(viewModel),
      DisplayState.CONTENT => _Content(viewModel),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage(this.viewModel);
  final ThematiqueDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyStatePlaceholder(
              illustration: Illustration.orange(AppIcons.construction),
              title: Strings.thematiquesErrorTitle,
              subtitle: Strings.thematiquesErrorSubtitle,
            ),
            const SizedBox(height: Margins.spacing_m),
            PrimaryActionButton(label: Strings.retry, onPressed: viewModel.onRetry),
            const SizedBox(height: Margins.spacing_xl),
            CreateCustomDemarche(),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel);
  final ThematiqueDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Text(Strings.thematiquesDemarcheDescription, style: TextStyles.textBaseMedium),
          ),
          const SizedBox(height: Margins.spacing_base),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.thematiques.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s, horizontal: Margins.spacing_base),
              child: _ThematiqueTile(viewModel.thematiques[index]),
            ),
          ),
          const SizedBox(height: Margins.spacing_base),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: CreateCustomDemarche(),
          ),
          const SizedBox(height: Margins.spacing_xl),
        ],
      ),
    );
  }
}

class _ThematiqueTile extends StatelessWidget {
  const _ThematiqueTile(this.thematique);
  final ThematiqueDemarcheItem thematique;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(thematique.title, style: TextStyles.textMBold),
            const SizedBox(height: Margins.spacing_base),
            PressedTip(Strings.thematiquesDemarchePressedTip),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              CreateDemarcheStep2Page.materialPageRoute(
                source: ThematiqueDemarcheSource(thematique.id),
                analyticsDetailsName: thematique.title,
              ));
        });
  }
}
