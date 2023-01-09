import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

class RendezvousListResult extends Equatable {
  final List<Rendezvous> rendezvous;
  final DateTime? dateDerniereMiseAJour;

  RendezvousListResult({required this.rendezvous, this.dateDerniereMiseAJour});

  @override
  List<Object?> get props => [rendezvous, dateDerniereMiseAJour];
}
