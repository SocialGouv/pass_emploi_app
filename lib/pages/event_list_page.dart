import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/events/event_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

// todo : onglet qui s'affiche uniquement pour un jeune mission locale ?

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventListPageViewModel>(
      onInit: (store) => store.dispatch(EventListRequestAction()),
      builder: (context, viewModel) => _Body(viewModel),
      converter: (store) => EventListPageViewModel.create(store),
      distinct: true,
    );
  }
}

class _Body extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
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
  }
}

class _Content extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _Content(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: Text(Strings.eventListHeaderText, style: TextStyles.textBaseRegular, textAlign: TextAlign.center),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: viewModel.events.length,
            padding: const EdgeInsets.all(Margins.spacing_s),
            separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
            itemBuilder: (context, index) {
              return viewModel.events[index].card(onTap: (id) => {});
            },
          ),
        ),
      ],
    );
  }
}

// todo presque doublon
extension _RendezvousIdCard on String {
  Widget card({required Function(String) onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Margins.spacing_s),
      child: RendezvousCard(
        converter: (store) => RendezvousCardViewModel.create(store, RendezvousStateSource.eventList, this),
        onTap: () => onTap(this),
      ),
    );
  }
}
