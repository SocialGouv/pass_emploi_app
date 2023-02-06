import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class ResultatRechercheContenu<Result> extends StatefulWidget {
  final BlocResultatRechercheViewModel<Result> viewModel;
  final FavoriListState<Result> Function(AppState) favorisState;
  final Widget Function(BuildContext, Result) buildItem;

  const ResultatRechercheContenu({
    super.key,
    required this.viewModel,
    required this.favorisState,
    required this.buildItem,
  });

  @override
  State<ResultatRechercheContenu<Result>> createState() => ResultatRechercheContenuState();
}

class ResultatRechercheContenuState<Result> extends State<ResultatRechercheContenu<Result>> {
  late ScrollController _scrollController;
  double _offsetBeforeLoading = 0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (widget.viewModel.withLoadMore && _scrollController.offset >= _scrollController.position.maxScrollExtent) {
        _offsetBeforeLoading = _scrollController.offset;
        widget.viewModel.onLoadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _onDidBuild);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FavorisStateContext<Result>(
      selectState: (store) => widget.favorisState(store.state),
      child: Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 120),
          controller: _scrollController,
          itemBuilder: (context, index) => widget.buildItem(context, widget.viewModel.items[index]),
          separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
          itemCount: widget.viewModel.items.length,
        ),
      ),
    );
  }

  void _onDidBuild() {
    if (_scrollController.hasClients) _scrollController.jumpTo(_offsetBeforeLoading);
  }

  void scrollToTop() {
    _offsetBeforeLoading = 0;
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }
}
