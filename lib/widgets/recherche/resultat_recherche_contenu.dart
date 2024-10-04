import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/favori/ids/favori_ids_state.dart';
import 'package:pass_emploi_app/presentation/recherche/bloc_resultat_recherche_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';

class ResultatRechercheContenu<Result> extends StatefulWidget {
  final String analyticsType;
  final BlocResultatRechercheViewModel<Result> viewModel;
  final FavoriIdsState<Result> Function(AppState) favorisState;
  final Widget Function(BuildContext, Result, int, BlocResultatRechercheViewModel<Result>) buildResultItem;

  const ResultatRechercheContenu({
    super.key,
    required this.analyticsType,
    required this.viewModel,
    required this.favorisState,
    required this.buildResultItem,
  });

  @override
  State<ResultatRechercheContenu<Result>> createState() => ResultatRechercheContenuState();
}

class ResultatRechercheContenuState<Result> extends State<ResultatRechercheContenu<Result>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
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
      child: AnimationLimiter(
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: Margins.spacing_base, bottom: 200),
          controller: _scrollController,
          itemCount: widget.viewModel.items.length,
          itemBuilder: (context, index) {
            final isLastItem = index == widget.viewModel.items.length - 1;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: AnimationDurations.fast,
              delay: AnimationDurations.veryFast,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Column(
                    children: [
                      widget.buildResultItem(
                        context,
                        widget.viewModel.items[index],
                        index,
                        widget.viewModel,
                      ),
                      if (widget.viewModel.withLoadMore && isLastItem) ...[
                        SizedBox(height: Margins.spacing_base),
                        _LoadMoreButton(onPressed: () => _onLoadMorePressed(context)),
                        SizedBox(height: Margins.spacing_huge),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
        ),
      ),
    );
  }

  void _onLoadMorePressed(BuildContext context) {
    widget.viewModel.onLoadMore();
    PassEmploiMatomoTracker.instance.trackScreen(
      AnalyticsScreenNames.rechercheAfficherPlusOffres(widget.analyticsType),
    );
  }

  void scrollToTop() {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }
}

class _LoadMoreButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _LoadMoreButton({required this.onPressed});

  @override
  State<_LoadMoreButton> createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends State<_LoadMoreButton> {
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: crossFadeState,
      sizeCurve: Curves.ease,
      duration: Duration(milliseconds: 200),
      firstChild: SizedBox(
        width: double.infinity,
        child: SecondaryButton(
          label: Strings.rechercheAfficherPlus,
          onPressed: () {
            widget.onPressed();
            setState(() => crossFadeState = CrossFadeState.showSecond);
          },
        ),
      ),
      secondChild: Center(
        child: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
