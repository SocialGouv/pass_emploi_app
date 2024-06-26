import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/voir_suggestions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class VoirSuggestionsRechercheCard extends StatelessWidget {
  final Function() onTapShowSuggestions;

  VoirSuggestionsRechercheCard({required this.onTapShowSuggestions});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoirSuggestionsRechercheViewModel>(
      converter: (store) => VoirSuggestionsRechercheViewModel.create(store),
      builder: (context, viewModel) => _Body(
        viewModel: viewModel,
        onTapShowSuggestions: onTapShowSuggestions,
      ),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final VoirSuggestionsRechercheViewModel viewModel;
  final Function() onTapShowSuggestions;

  _Body({required this.viewModel, required this.onTapShowSuggestions});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AnimationDurations.medium,
      opacity: viewModel.hasSuggestionsRecherche ? 1 : 0,
      child: viewModel.hasSuggestionsRecherche
          ? CardContainer(
              child: Column(
                children: [
                  _Icon(),
                  _Title(),
                  _Subtitle(),
                  _Button(onTapShowSuggestions: onTapShowSuggestions),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(AppIcons.add_alert_rounded, color: AppColors.accent2, size: 40),
    );
  }
}

class _Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_s),
      child: Text(
        Strings.nouvellesSuggestionsDeRechercheTitre,
        style: TextStyles.textBaseBold,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Text(Strings.nouvellesSuggestionsDeRechercheDescription, style: TextStyles.textSRegular()),
    );
  }
}

class _Button extends StatelessWidget {
  final Function() onTapShowSuggestions;

  _Button({required this.onTapShowSuggestions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_l, bottom: Margins.spacing_s),
      child: PrimaryActionButton(
        label: Strings.voirSuggestionsDeRecherche,
        withShadow: false,
        onPressed: onTapShowSuggestions,
      ),
    );
  }
}
