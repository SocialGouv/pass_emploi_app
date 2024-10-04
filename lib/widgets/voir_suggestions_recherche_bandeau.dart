import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/presentation/voir_suggestions_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/apparition_animation.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class VoirSuggestionsRechercheBandeau extends StatelessWidget {
  final Function() onTapShowSuggestions;
  final EdgeInsets? padding;

  VoirSuggestionsRechercheBandeau({required this.onTapShowSuggestions, this.padding});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoirSuggestionsRechercheViewModel>(
      converter: (store) => VoirSuggestionsRechercheViewModel.create(store),
      onInit: (store) => store.dispatch(SuggestionsRechercheRequestAction()),
      builder: (context, viewModel) => _Body(
        viewModel: viewModel,
        onTapShowSuggestions: onTapShowSuggestions,
        padding: padding,
      ),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final VoirSuggestionsRechercheViewModel viewModel;
  final Function() onTapShowSuggestions;
  final EdgeInsets? padding;

  _Body({required this.viewModel, required this.onTapShowSuggestions, this.padding});

  @override
  Widget build(BuildContext context) {
    if (viewModel.hasSuggestionsRecherche) {
      return ApparitionAnimation(
        child: Semantics(
          button: true,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: _Bandeau(
              onTapShowSuggestions: onTapShowSuggestions,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _Icon(),
                  _Text(),
                  _Chevron(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _Icon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Icon(AppIcons.add_alert_rounded, color: AppColors.accent1, size: Dimens.icon_size_m),
    );
  }
}

class _Text extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(Strings.vosSuggestionsAlertes, style: TextStyles.textBaseBold),
    );
  }
}

class _Chevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Icon(AppIcons.chevron_right_rounded, color: AppColors.contentColor),
    );
  }
}

class _Bandeau extends StatelessWidget {
  final Widget child;
  final Function() onTapShowSuggestions;

  _Bandeau({required this.child, required this.onTapShowSuggestions});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      onTap: onTapShowSuggestions,
      child: child,
    );
  }
}
