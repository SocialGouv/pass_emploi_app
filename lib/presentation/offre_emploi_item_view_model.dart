import 'package:equatable/equatable.dart';

class OffreEmploiItemViewModel extends Equatable {
  final String id;
  final String title;
  final String? companyName;
  final String contractType;
  final String? duration;
  final String? location;

  OffreEmploiItemViewModel(
    this.id,
    this.title,
    this.companyName,
    this.contractType,
    this.duration,
    this.location,
  );

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
