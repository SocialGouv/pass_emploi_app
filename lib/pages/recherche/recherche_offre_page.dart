import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/actions_recherche_view_model.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/recherche/actions_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/bloc_criteres_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/bloc_resultat_recherche.dart';
import 'package:pass_emploi_app/widgets/recherche/resultat_recherche_contenu.dart';
import 'package:redux/redux.dart';

abstract class RechercheOffrePage<Result> extends StatefulWidget {
  ActionsRechercheViewModel buildActionsRechercheViewModel(Store<AppState> store);

  String? appBarTitle();

  String analyticsType();

  String placeHolderTitle();

  String placeHolderSubtitle();

  RechercheState rechercheState(AppState appState);

  FavoriIdsState<Result> favorisState(AppState appState);

  Widget buildAlertBottomSheet();

  Future<bool?>? buildFiltresBottomSheet(BuildContext context);

  Widget buildCriteresContentWidget({required Function(int) onNumberOfCriteresChanged});

  Widget buildResultItem(
    BuildContext context,
    Result item,
    int index,
    BlocResultatRechercheViewModel<Result> resultViewModel,
  );

  @override
  State<RechercheOffrePage<Result>> createState() => _RechercheOffrePageState();
}

class _RechercheOffrePageState<Result> extends State<RechercheOffrePage<Result>> {
  Store<AppState>? _store;
  final _listResultatKey = GlobalKey();

  @override
  void dispose() {
    _store?.dispatch(RechercheResetAction<Result>());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _store = StoreProvider.of<AppState>(context);
    const backgroundColor = AppColors.grey100;
    return Tracker(
      tracking: AnalyticsScreenNames.rechercheInitiale(widget.analyticsType()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: widget.appBarTitle() != null
            ? SecondaryAppBar(title: widget.appBarTitle()!, backgroundColor: backgroundColor)
            : null,
        floatingActionButton: ActionsRecherche(
          buildViewModel: widget.buildActionsRechercheViewModel,
          buildAlertBottomSheet: widget.buildAlertBottomSheet,
          buildFiltresBottomSheet: () => widget.buildFiltresBottomSheet(context),
          onFiltreApplied: _onFiltreApplied,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(
            left: Margins.spacing_base,
            top: Margins.spacing_base,
            right: Margins.spacing_base,
          ),
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocCriteresRecherche<Result>(
                  rechercheState: widget.rechercheState,
                  buildCriteresContentWidget: widget.buildCriteresContentWidget,
                ),
                BlocResultatRecherche<Result>(
                  listResultatKey: _listResultatKey,
                  rechercheState: widget.rechercheState,
                  favorisState: widget.favorisState,
                  buildResultItem: widget.buildResultItem,
                  analyticsType: widget.analyticsType(),
                  placeHolderTitle: widget.placeHolderTitle(),
                  placeHolderSubtitle: widget.placeHolderSubtitle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFiltreApplied() => (_listResultatKey.currentState as ResultatRechercheContenuState?)?.scrollToTop();
}
