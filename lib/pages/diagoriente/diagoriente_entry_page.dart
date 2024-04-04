import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_webview_page.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_webview_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class DiagorienteEntryPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => DiagorienteEntryPage());

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.diagorienteEntryPage,
      child: StoreConnector<AppState, DiagorienteEntryPageViewModel>(
        onInit: (store) => store.dispatch(DiagorientePreferencesMetierRequestAction()),
        converter: (store) => DiagorienteEntryPageViewModel.create(store),
        builder: (context, vm) => _Scaffold(vm),
        distinct: true,
      ),
    );
  }
}

class _Scaffold extends StatelessWidget {
  final DiagorienteEntryPageViewModel viewModel;

  const _Scaffold(this.viewModel);

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.diagorienteEntryPageTitle, backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: _Body(viewModel),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final DiagorienteEntryPageViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return switch (viewModel.displayState) {
      DisplayState.FAILURE => Retry(Strings.diagorienteMetiersCardError, () => viewModel.onRetry()),
      DisplayState.CONTENT => _Content(viewModel),
      _ => Center(child: CircularProgressIndicator()),
    };
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel);

  final DiagorienteEntryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (viewModel.withMetiersFavoris) ...[
          _DiagorienteMetiersFavorisCard(viewModel),
          SizedBox(height: Margins.spacing_base),
        ],
        _DecouvrirLesMetiersCard(viewModel),
      ],
    );
  }
}

class _DiagorienteMetiersFavorisCard extends StatelessWidget {
  const _DiagorienteMetiersFavorisCard(this.viewModel);

  final DiagorienteEntryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: () => Navigator.push(
        context,
        DiagorienteWebviewPage.materialPageRoute(DiagorienteWebviewMode.favoris),
      ).then((_) => viewModel.onRetry()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.diagorienteMetiersFavorisCardTitle, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_m),
          Row(
            children: [
              Text(Strings.diagorienteMetiersFavorisCardSubtitle, style: TextStyles.textBaseRegular),
              SizedBox(height: Margins.spacing_m),
              Expanded(child: PressedTip(Strings.diagorienteMetiersFavorisCardPressedTip)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecouvrirLesMetiersCard extends StatelessWidget {
  const _DecouvrirLesMetiersCard(this.viewModel);

  final DiagorienteEntryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.diagorienteMetiersCardTitle, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.diagorienteMetiersCardSubtitle, style: TextStyles.textBaseRegular),
          SizedBox(height: Margins.spacing_m),
          PrimaryActionButton(
            label: Strings.diagorienteMetiersCardButton,
            onPressed: () => Navigator.push(
              context,
              DiagorienteWebviewPage.materialPageRoute(DiagorienteWebviewMode.chatbot),
            ).then((_) => viewModel.onRetry()),
          ),
        ],
      ),
    );
  }
}
