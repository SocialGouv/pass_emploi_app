import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_actions.dart';
import 'package:pass_emploi_app/pages/demarche/create_custom_demarche.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_step2_page.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class ThematiquesDemarchePage extends StatelessWidget {
  const ThematiquesDemarchePage({super.key});
  // final DemarcheSource source;

  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => ThematiquesDemarchePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.thematiquesDemarche,
      child: StoreConnector<AppState, ThematiquesDemarchePageViewModel>(
        onInit: (store) => store.dispatch(ThematiquesDemarcheRequestAction()),
        converter: (store) => ThematiquesDemarchePageViewModel.create(store),
        builder: (context, viewModel) => _Scaffold(viewModel),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  const _Scaffold(this.viewModel);
  final ThematiquesDemarchePageViewModel viewModel;

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
  final ThematiquesDemarchePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case DisplayState.FAILURE:
        return _ErrorMessage();
      case DisplayState.LOADING:
        return const Center(child: CircularProgressIndicator());
      case DisplayState.CONTENT:
        return _Content(viewModel);
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage();

  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // TODO:
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel);
  final ThematiquesDemarchePageViewModel viewModel;

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
  final ThematiquesDemarcheItem thematique;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.format_list_bulleted_rounded, color: AppColors.primary),
                const SizedBox(width: Margins.spacing_s),
                Expanded(child: Text(thematique.title, style: TextStyles.textMBold)),
              ],
            ),
            const SizedBox(height: Margins.spacing_base),
            PressedTip(Strings.thematiquesDemarchePressedTip),
          ],
        ),
        onTap: () {
          Navigator.push(context, CreateDemarcheStep2Page.materialPageRoute()).then((value) {
            // forward result to previous page
            if (value != null) Navigator.pop(context, value);
          });
        });
  }
}
