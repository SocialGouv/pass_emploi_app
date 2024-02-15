import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class EvenementEmploiDetailsPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? tag;
  final String titre;
  final String date;
  final String heure;
  final String lieu;
  final String? description;
  final String? url;
  final Function(String eventId) retry;

  EvenementEmploiDetailsPageViewModel({
    required this.displayState,
    required this.tag,
    required this.titre,
    required this.date,
    required this.heure,
    required this.lieu,
    required this.description,
    required this.url,
    required this.retry,
  });

  factory EvenementEmploiDetailsPageViewModel.create(Store<AppState> store) {
    final state = store.state.evenementEmploiDetailsState;
    final displayState = _displayState(state);
    final details = _details(state);

    if (details == null) return EvenementEmploiDetailsPageViewModel.blank(store, displayState);

    return EvenementEmploiDetailsPageViewModel(
      displayState: displayState,
      tag: details.typeEvenement,
      titre: details.titre ?? '',
      date: details.dateTimeDebut?.toDayWithFullMonth() ?? '',
      heure: _heure(details.dateTimeDebut, details.dateTimeFin),
      lieu: details.ville != null && details.codePostal != null ? "${details.codePostal} - ${details.ville}" : '',
      description: details.description,
      url: details.url,
      retry: (eventId) => store.dispatch(EvenementEmploiDetailsRequestAction(eventId)),
    );
  }

  factory EvenementEmploiDetailsPageViewModel.blank(Store<AppState> store, DisplayState displayState) {
    return EvenementEmploiDetailsPageViewModel(
      displayState: displayState,
      tag: '',
      titre: '',
      date: '',
      heure: '',
      lieu: '',
      description: '',
      url: null,
      retry: (eventId) => store.dispatch(EvenementEmploiDetailsRequestAction(eventId)),
    );
  }

  @override
  List<Object?> get props => [displayState, tag, titre, date, heure, lieu, description, url];
}

DisplayState _displayState(EvenementEmploiDetailsState state) {
  return switch (state) {
    EvenementEmploiDetailsSuccessState _ => DisplayState.CONTENT,
    EvenementEmploiDetailsFailureState _ => DisplayState.FAILURE,
    _ => DisplayState.LOADING,
  };
}

EvenementEmploiDetails? _details(EvenementEmploiDetailsState state) {
  return switch (state) { final EvenementEmploiDetailsSuccessState e => e.details, _ => null };
}

String _heure(DateTime? heureDebut, DateTime? heureFin) {
  if (heureDebut == null || heureFin == null) return '';
  return "${heureDebut.toHourWithHSeparator()} - ${heureFin.toHourWithHSeparator()}";
}
