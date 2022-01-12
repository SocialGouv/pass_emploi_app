import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';

class OffreEmploiItemViewModel extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String? duration;
  final String? location;

  OffreEmploiItemViewModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.duration,
    required this.location,
  });

  factory OffreEmploiItemViewModel.create(OffreEmploi offre) {
    return OffreEmploiItemViewModel(
      id: offre.id,
      title: offre.title,
      companyName: offre.companyName,
      contractType: offre.contractType,
      duration: offre.duration,
      location: offre.location,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        companyName,
        contractType,
        location,
        duration,
      ];
}
