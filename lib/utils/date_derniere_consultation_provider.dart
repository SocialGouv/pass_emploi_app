import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/date_consultation_offre/date_derniere_consultation_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

class DateDerniereConsultationProvider extends StatelessWidget {
  const DateDerniereConsultationProvider({super.key, required this.id, required this.builder});
  final String id;
  final Widget Function(DateTime? dateDerniereConsultation) builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, DateTime?>(
        converter: (store) => store.getOffreDateDerniereConsultationOrNull(id),
        builder: (context, dateDerniereConsultation) {
          return builder(dateDerniereConsultation);
        });
  }
}
