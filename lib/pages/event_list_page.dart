import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/events/event_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/refresh_indicator_ext.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.eventList,
      child: StoreConnector<AppState, EventListPageViewModel>(
        onInit: (store) => store.dispatch(EventListRequestAction(DateTime.now())),
        builder: (context, viewModel) => _Body(viewModel),
        converter: (store) => EventListPageViewModel.create(store),
        distinct: true,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AnimationDurations.fast,
      child: switch (viewModel.displayState) {
        DisplayState.LOADING => _EventListLoading(),
        DisplayState.EMPTY => _EmptyListPlaceholder(viewModel),
        DisplayState.CONTENT => _Content(viewModel),
        DisplayState.FAILURE => Retry(Strings.eventListError, () => viewModel.onRetry()),
      },
    );
  }
}

class _EmptyListPlaceholder extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _EmptyListPlaceholder(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicatorAddingScrollview(
      onRefresh: () async => viewModel.onRetry(),
      child: Center(
        child: EmptyStatePlaceholder(
          illustration: Illustration.grey(Icons.event, withWhiteBackground: true),
          title: Strings.eventListEmpty,
          subtitle: Strings.eventListEmptySubtitle,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacing_base),
            child: Text(Strings.eventListHeaderText, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => viewModel.onRetry(),
              child: ListView.separated(
                itemCount: viewModel.eventIds.length,
                separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
                itemBuilder: (context, index) {
                  final eventId = viewModel.eventIds[index];
                  return switch (eventId) {
                    final AnimationCollectiveId a => a.id.rendezvousCard(
                        context: context,
                        stateSource: RendezvousStateSource.eventListAnimationsCollectives,
                        trackedEvent: EvenementEngagement.ANIMATION_COLLECTIVE_AFFICHEE,
                      ),
                    final SessionMiloId s => s.id.rendezvousCard(
                        context: context,
                        stateSource: RendezvousStateSource.eventListSessionsMilo,
                        trackedEvent: EvenementEngagement.ANIMATION_COLLECTIVE_AFFICHEE,
                      ),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventListLoading extends StatelessWidget {
  const _EventListLoading();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimatedListLoader(
      placeholders: placeholders,
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 30,
        ),
        SizedBox(height: Margins.spacing_s),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 30,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 170,
        ),
      ];
}
