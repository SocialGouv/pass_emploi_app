import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_extensions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsViewModel extends Equatable {
  final String title;
  final String date;
  final String hourAndDuration;

  RendezvousDetailsViewModel({
    required this.title,
    required this.date,
    required this.hourAndDuration,
  });

  factory RendezvousDetailsViewModel.create(Store<AppState> store, String rdvId) {
    final state = store.state.rendezvousState;
    if (state is! RendezvousSuccessState) throw Exception('Rendezvous state is not successful');
    if (state.rendezvous.where((e) => e.id == rdvId).isEmpty) throw Exception('No Rendezvous matching id $rdvId');
    final rdv = state.rendezvous.firstWhere((e) => e.id == rdvId);
    return RendezvousDetailsViewModel(
      title: rdv.takeTypeLabelOrPrecision(),
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: "${rdv.date.toHour()} (${_toDuration(rdv.duration)})",
    );
  }

  @override
  List<Object?> get props {
    return [
      title,
      date,
      hourAndDuration,
    ];
  }
}

String _toDuration(int duration) {
  final hours = duration ~/ 60;
  final minutes = duration % 60;
  if (hours == 0) return '${minutes}min';
  if (minutes == 0) return '${hours}h';
  return '${hours}h$minutes';
}
