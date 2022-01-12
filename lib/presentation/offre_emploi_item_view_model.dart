import 'package:equatable/equatable.dart';

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
