import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/events/event_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
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
    return Builder(builder: (context) {
      switch (viewModel.displayState) {
        case DisplayState.LOADING:
          return Center(child: CircularProgressIndicator());
        case DisplayState.EMPTY:
          return Center(child: Text(Strings.eventListEmpty, textAlign: TextAlign.center));
        case DisplayState.CONTENT:
          return _Content(viewModel);
        case DisplayState.FAILURE:
          return Center(child: Retry(Strings.eventListError, () => viewModel.onRetry()));
      }
    });
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
            child: ListView.separated(
              itemCount: viewModel.eventIds.length,
              separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
              itemBuilder: (context, index) {
                final eventId = viewModel.eventIds[index];
                return switch (eventId) {
                  final AnimationCollectiveId a => a.id.rendezvousCard(
                      context: context,
                      stateSource: RendezvousStateSource.eventList,
                      trackedEvent: EventType.ANIMATION_COLLECTIVE_AFFICHEE,
                    ),
                  final SessionMiloId s => s.id.rendezvousCard(
                      context: context,
                      stateSource: RendezvousStateSource.sessionMiloList,
                      trackedEvent: EventType.ANIMATION_COLLECTIVE_AFFICHEE,
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
