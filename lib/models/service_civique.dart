import 'package:equatable/equatable.dart';

class ServiceCivique extends Equatable {
  final String id;
  final String title;
  final String? domain;
  final String? companyName;
  final String? location;
  final String? startDate;

  ServiceCivique({
    required this.id,
    required this.title,
    required this.domain,
    required this.companyName,
    required this.location,
    required this.startDate,
  });

  factory ServiceCivique.fromJson(dynamic json) {
    final String? stringDate = (json["dateDeDebut"] as String?);
    return ServiceCivique(
      id: json["id"] as String,
      title: json["titre"] as String,
      domain: json["domaine"] as String,
      companyName: json["organisation"] as String?,
      location: json["ville"] as String?,
      startDate: stringDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titre": title,
      "domaine": domain,
      "organisation": companyName,
      "ville": location,
      "dateDeDebut": startDate,
    };
  }

  @override
  List<Object?> get props => [id, title, domain, companyName, location, startDate];
}
