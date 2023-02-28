import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/pages/diagoriente/diagoriente_chat_bot_page.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/pressed_tip.dart';

class DiagorienteEntryPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => DiagorienteEntryPage());

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.diagorienteEntryPage,
      child: StoreConnector<AppState, DiagorienteEntryPageViewModel>(
        onInit: (store) => store.dispatch(DiagorienteMetiersFavorisRequestAction()),
        converter: (store) => DiagorienteEntryPageViewModel.create(store),
        builder: _builder,
        onDispose: (store) {
          store.dispatch(DiagorienteUrlsResetAction());
          store.dispatch(DiagorienteMetiersFavorisResetAction());
        },
        onDidChange: (_, currentViewModel) => _onDidChange(context, currentViewModel),
        distinct: true,
      ),
    );
  }

  Widget _builder(BuildContext context, DiagorienteEntryPageViewModel viewModel) {
    const backgroundColor = AppColors.grey100;
    final withFailure = viewModel.showError;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.diagorienteEntryPageTitle, backgroundColor: backgroundColor),
      body: Padding(
        padding: const EdgeInsets.all(Margins.spacing_base),
        child: Column(
          children: [
            if (withFailure) ...[
              _FailureMessage(),
              SizedBox(height: Margins.spacing_m),
            ],
            if (viewModel.showMetiersFavoris) ...[
              _DiagorienteMetiersFavorisCard(viewModel),
              SizedBox(height: Margins.spacing_base),
            ],
            _DecouvrirLesMetiersCard(viewModel),
          ],
        ),
      ),
    );
  }

  void _onDidChange(BuildContext context, DiagorienteEntryPageViewModel viewModel) {
    switch (viewModel.navigatingTo) {
      case DiagorienteNavigatingTo.chatBotPage:
        Navigator.push(context, DiagorienteChatBotPage.materialPageRoute());
        break;
      default:
        break;
    }
  }
}

class _DiagorienteMetiersFavorisCard extends StatelessWidget {
  const _DiagorienteMetiersFavorisCard(this.viewModel);

  final DiagorienteEntryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final withLoading = viewModel.shouldDisableButtons;

    return ApparitionAnimation(
      child: CardContainer(
        onTap: withLoading ? null : () => viewModel.requestUrls(),
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
      ),
    );
  }
}

class _DecouvrirLesMetiersCard extends StatelessWidget {
  const _DecouvrirLesMetiersCard(this.viewModel);

  final DiagorienteEntryPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final withLoading = viewModel.shouldDisableButtons;
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
            onPressed: withLoading ? null : () => viewModel.requestUrls(),
          ),
        ],
      ),
    );
  }
}

class _FailureMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcons.error_rounded, color: AppColors.warning),
        SizedBox(width: Margins.spacing_base),
        Expanded(
          child: Text(
            Strings.diagorienteMetiersCardError,
            style: TextStyles.textSRegular(color: AppColors.warning),
          ),
        ),
      ],
    );
  }
}
