import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/recherche/recherche_message_placeholder.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';

class BlocResultatRecherche<Result> extends StatefulWidget {
  final Key listResultatKey;
  final RechercheState Function(AppState) rechercheState;
  final FavoriIdsState<Result> Function(AppState) favorisState;
  final Widget Function(BuildContext, Result, int, BlocResultatRechercheViewModel<Result>) buildResultItem;
  final String analyticsType;
  final String placeHolderTitle;
  final String placeHolderSubtitle;

  BlocResultatRecherche({
    required this.listResultatKey,
    required this.rechercheState,
    required this.favorisState,
    required this.buildResultItem,
    required this.analyticsType,
    required this.placeHolderTitle,
    required this.placeHolderSubtitle,
  });

  @override
  State<BlocResultatRecherche<Result>> createState() => _BlocResultatRechercheState<Result>();
}

class _BlocResultatRechercheState<Result> extends State<BlocResultatRecherche<Result>> {
  int _numberOfSearchSent = 0;
  int? _lastNumberSearchAnalyticSent;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocResultatRechercheViewModel<Result>>(
      builder: _builder,
      converter: (store) => BlocResultatRechercheViewModel.create(store, widget.rechercheState),
      onDidChange: (previousViewModel, viewModel) {
        _trackSearchResults(viewModel, previousViewModel, context);
      },
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocResultatRechercheViewModel<Result> viewModel) {
    switch (viewModel.displayState) {
      case BlocResultatRechercheDisplayState.recherche:
        return RechercheMessagePlaceholder(widget.placeHolderTitle, subtitle: widget.placeHolderSubtitle);
      case BlocResultatRechercheDisplayState.empty:
        return RechercheMessagePlaceholder(Strings.noContentErrorTitle, subtitle: Strings.noContentErrorSubtitle);
      case BlocResultatRechercheDisplayState.results:
      case BlocResultatRechercheDisplayState.editRecherche:
        final bool withOpacity = viewModel.displayState == BlocResultatRechercheDisplayState.editRecherche;
        return GestureDetector(
          onTapDown: (_) => viewModel.onListWithOpacityTouch(),
          child: AnimatedOpacity(
            opacity: withOpacity ? 0.2 : 1,
            duration: Duration(milliseconds: 200),
            child: AbsorbPointer(
              absorbing: withOpacity,
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    // A11y - to close bandeau recherche when focus goes to the list
                    context.dispatch(RechercheCloseCriteresAction<Result>());
                  }
                },
                child: ResultatRechercheContenu<Result>(
                  key: widget.listResultatKey,
                  analyticsType: widget.analyticsType,
                  viewModel: viewModel,
                  favorisState: widget.favorisState,
                  buildResultItem: widget.buildResultItem,
                ),
              ),
            ),
          ),
        );
    }
  }

  void _trackSearchResults(
    BlocResultatRechercheViewModel<Result> viewModel,
    BlocResultatRechercheViewModel<Result>? previousViewModel,
    BuildContext context,
  ) {
    if (viewModel.displayState == BlocResultatRechercheDisplayState.recherche) _numberOfSearchSent += 1;
    if (viewModel.displayState == BlocResultatRechercheDisplayState.results) {
      if (_lastNumberSearchAnalyticSent == _numberOfSearchSent) return;
      _lastNumberSearchAnalyticSent = _numberOfSearchSent;

      PassEmploiMatomoTracker.instance.trackScreen(
        _numberOfSearchSent == 0
            ? AnalyticsScreenNames.rechercheInitialeResultats(widget.analyticsType)
            : AnalyticsScreenNames.rechercheModifieeResultats(widget.analyticsType),
      );
    }
  }
}
