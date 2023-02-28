import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_criteres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recheche_expansion_tile.dart';

class BlocCriteresRecherche<Result> extends StatefulWidget {
  final RechercheState Function(AppState) rechercheState;
  final Widget Function({required Function(int) onNumberOfCriteresChanged}) buildCriteresContentWidget;

  BlocCriteresRecherche({required this.rechercheState, required this.buildCriteresContentWidget});

  @override
  State<BlocCriteresRecherche<Result>> createState() => _BlocCriteresRechercheState<Result>();
}

class _BlocCriteresRechercheState<Result> extends State<BlocCriteresRecherche<Result>> {
  int? _criteresActifsCount;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel<Result>>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store, widget.rechercheState),
      builder: _builder,
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, BlocCriteresRechercheViewModel<Result> viewModel) {
    return CriteresRechercheExpansionTile(
      initiallyExpanded: viewModel.isOpen,
      onExpansionChanged: viewModel.onExpansionChanged,
      criteresActifsCount: _criteresActifsCount ?? 0,
      child: widget.buildCriteresContentWidget(
        onNumberOfCriteresChanged: (number) {
          setState(() => _criteresActifsCount = number);
        },
      ),
    );
  }
}
