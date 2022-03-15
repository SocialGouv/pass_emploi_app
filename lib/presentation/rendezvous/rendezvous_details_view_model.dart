import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsViewModel extends Equatable {
  final String title;

  RendezvousDetailsViewModel({
    required this.title,
  });

  factory RendezvousDetailsViewModel.create(Store<AppState> store, String rdvId) {
    final state = store.state.rendezvousState;
    if (state is! RendezvousSuccessState) throw Exception('Rendezvous state is not successful');
    if (state.rendezvous.where((e) => e.id == rdvId).isEmpty) throw Exception('No Rendezvous matching id $rdvId');
    final rdv = state.rendezvous.firstWhere((e) => e.id == rdvId);
    return RendezvousDetailsViewModel(
      title: rdv.type.label,
    );
  }

  @override
  List<Object?> get props {
    return [
      title,
    ];
  }
}
