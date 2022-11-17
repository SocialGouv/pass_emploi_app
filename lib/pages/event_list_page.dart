import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/events/list/event_list_actions.dart';
import 'package:pass_emploi_app/presentation/events/event_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventListPageViewModel>(
      onInit: (store) => store.dispatch(EventListRequestAction()),
      builder: (context, viewModel) => _Container(viewModel),
      converter: (store) => EventListPageViewModel.create(store),
      distinct: true,
    );
  }
}

class _Container extends StatelessWidget {
  final EventListPageViewModel viewModel;

  _Container(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

