import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_criteres_cherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/recherche/criteres_recheche_expansion_tile.dart';

class BlocCriteresRecherche<Result> extends StatelessWidget {
  final RechercheState Function(AppState) rechercheState;
  final Widget Function({required Function(int) onNumberOfCriteresChanged}) buildCriteresContentWidget;

  BlocCriteresRecherche({required this.rechercheState, required this.buildCriteresContentWidget});

  @override
  Widget build(BuildContext context) {
    // 2 widgets are used to ensure setState is only called on the _BlocCriteresRechercheTile widget
    return Stack(
      children: [
        _BlocCriteresRechercheTile<Result>(
          rechercheState: rechercheState,
          buildCriteresContentWidget: buildCriteresContentWidget,
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.all(Margins.spacing_base),
            child: _Chevron<Result>(rechercheState: rechercheState),
          ),
        )
      ],
    );
  }
}

class _BlocCriteresRechercheTile<Result> extends StatefulWidget {
  final RechercheState Function(AppState) rechercheState;
  final Widget Function({required Function(int) onNumberOfCriteresChanged}) buildCriteresContentWidget;

  _BlocCriteresRechercheTile({required this.rechercheState, required this.buildCriteresContentWidget});

  @override
  State<_BlocCriteresRechercheTile<Result>> createState() => _BlocCriteresRechercheTileState<Result>();
}

class _BlocCriteresRechercheTileState<Result> extends State<_BlocCriteresRechercheTile<Result>> {
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
          SemanticsService.announce(
            intl.Intl.plural(
              _criteresActifsCount ?? 0,
              zero: Strings.rechercheCriteresActifsZero,
              one: Strings.rechercheCriteresActifsOne,
              other: Strings.rechercheCriteresActifsPlural(_criteresActifsCount ?? 0),
            ),
            TextDirection.ltr,
          );
        },
      ),
    );
  }
}

class _Chevron<Result> extends StatelessWidget {
  final RechercheState Function(AppState) rechercheState;

  const _Chevron({required this.rechercheState});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCriteresRechercheViewModel<Result>>(
      converter: (store) => BlocCriteresRechercheViewModel.create(store, rechercheState),
      builder: (_, viewModel) => _ChevronIcon(isOpen: viewModel.isOpen),
      distinct: true,
    );
  }
}

class _ChevronIcon extends StatefulWidget {
  final bool isOpen;

  const _ChevronIcon({required this.isOpen});

  @override
  State<_ChevronIcon> createState() => _ChevronIconState();
}

class _ChevronIconState extends State<_ChevronIcon> {
  bool initialBuild = true;

  @override
  void didUpdateWidget(covariant _ChevronIcon oldWidget) {
    initialBuild = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // On initial build, we don't want to display the chevron as the parent widget cannot yet be closed
    if (initialBuild) return SizedBox.shrink();
    // IgnorePointer required to let parent widget handle the tap event
    return IgnorePointer(
      child: AnimatedRotation(
        turns: !widget.isOpen ? -0.5 : 0,
        duration: AnimationDurations.medium,
        curve: Curves.ease,
        child: Icon(Icons.expand_less_rounded, color: widget.isOpen ? AppColors.primary : Colors.white),
      ),
    );
  }
}
