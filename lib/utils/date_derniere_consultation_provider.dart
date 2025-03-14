import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_derniere_consultation_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DateDerniereActionProvider extends StatelessWidget {
  const DateDerniereActionProvider({super.key, required this.id, required this.builder});
  final String id;
  final Widget Function(DateDerniereActionViewModel viewModel) builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DateDerniereActionViewModel>(
        converter: (store) => DateDerniereActionViewModel.create(store, id),
        builder: (context, dateDerniereConsultation) => builder(dateDerniereConsultation));
  }
}

class DateDerniereActionViewModel {
  final DateTime? dateDerniereConsultation;
  final DateTime? datePostulation;

  DateDerniereActionViewModel({required this.dateDerniereConsultation, required this.datePostulation});

  factory DateDerniereActionViewModel.create(Store<AppState> store, String id) {
    return DateDerniereActionViewModel(
      dateDerniereConsultation: store.getOffreDateDerniereConsultationOrNull(id),
      datePostulation: store.state.offreEmploiFavorisIdsState.datePostulationOf(id),
    );
  }
}
