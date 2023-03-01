import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_chat_bot_page.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_chat_bot_page_view_model.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
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
        builder: _builder,
        onDispose: (store) => store.dispatch(DiagorientePreferencesMetierResetAction()),
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, DiagorienteEntryPageViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.FAILURE:
        return Center(child: Retry(Strings.diagorienteMetiersCardError, () => viewModel.onRetry()));
      case DisplayState.CONTENT:
        return _Content(viewModel.withMetiersFavoris);
      default:
        return Center(child: CircularProgressIndicator());
    }
  }
}

class _Content extends StatelessWidget {
  const _Content(this.withMetiersFavoris);

  final bool withMetiersFavoris;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Column(
        children: [
          if (withMetiersFavoris) ...[
            _DiagorienteMetiersFavorisCard(),
            SizedBox(height: Margins.spacing_base),
          ],
          _DecouvrirLesMetiersCard(),
        ],
      ),
    );
  }
}

class _DiagorienteMetiersFavorisCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: () => Navigator.push(
        context,
        DiagorienteChatBotPage.materialPageRoute(DiagorienteChatBotPageMode.favoris),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.diagorienteMetiersFavorisCardTitle, style: TextStyles.textMBold),
          SizedBox(height: Margins.spacing_m),
          Text(Strings.diagorienteMetiersFavorisCardSubtitle, style: TextStyles.textBaseRegular),
          SizedBox(height: Margins.spacing_m),
          PressedTip(Strings.diagorienteMetiersFavorisCardPressedTip),
        ],
      ),
    );
  }
}

class _DecouvrirLesMetiersCard extends StatelessWidget {
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
              DiagorienteChatBotPage.materialPageRoute(DiagorienteChatBotPageMode.chatbot),
            ),
          ),
        ],
      ),
    );
  }
}
