import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/remote_campagne_accueil.dart';

class RemoteCampagneAccueilState extends Equatable {
  final List<RemoteCampagneAccueil> campagnes;

  RemoteCampagneAccueilState({this.campagnes = const []});

  @override
  List<Object?> get props => [campagnes];
}
