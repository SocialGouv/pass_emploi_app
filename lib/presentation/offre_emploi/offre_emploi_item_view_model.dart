import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/presentation/offre_emploi/offre_emploi_origin_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';

const String _missionInterimCode = 'MIS';

class OffreEmploiItemViewModel extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String? duration;
  final String? location;
  final OffreEmploiOriginViewModel? originViewModel;

  OffreEmploiItemViewModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.contractType,
    required this.duration,
    required this.location,
    required this.originViewModel,
  });

  factory OffreEmploiItemViewModel.create(OffreEmploi offre) {
    return OffreEmploiItemViewModel(
      id: offre.id,
      title: offre.title,
      companyName: offre.companyName,
      contractType: _contractType(offre),
      duration: offre.duration,
      location: offre.location,
      originViewModel: OffreEmploiOriginViewModel.from(offre.origin),
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
        originViewModel,
      ];
}

String _contractType(OffreEmploi offre) {
  return switch (offre.contractType) {
    _missionInterimCode => Strings.interim,
    _ => offre.contractType,
  };
}
