import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/brand.dart';

class RemoteCampagneAccueil extends Equatable {
  final String id;
  final String title;
  final String cta;
  final String url;
  final Brand? brand;
  final DateTime dateFin;
  final DateTime dateDebut;
  final List<Accompagnement> accompagnements;

  RemoteCampagneAccueil({
    required this.id,
    required this.title,
    required this.cta,
    required this.url,
    required this.brand,
    required this.dateFin,
    required this.dateDebut,
    required this.accompagnements,
  });

  static RemoteCampagneAccueil fromJson(Map<String, dynamic> json) {
    final Brand? brand = json['brand'] != null ? BrandExt.fromString(json['brand'] as String) : null;
    final List<Accompagnement> accompagnements =
        (json['accompagnements'] as List).map((e) => AccompagnementExt.fromJson(e as String)).toList();
    return RemoteCampagneAccueil(
      id: json['id'] as String,
      title: json['title'] as String,
      cta: json['cta'] as String,
      url: json['url'] as String,
      brand: brand,
      dateFin: DateTime.fromMillisecondsSinceEpoch(json['dateFin'] as int),
      dateDebut: DateTime.fromMillisecondsSinceEpoch(json['dateDebut'] as int),
      accompagnements: accompagnements,
    );
  }

  bool get isActive => dateDebut.isBefore(DateTime.now()) && dateFin.isAfter(DateTime.now());

  @override
  List<Object?> get props => [id, title, cta, url, brand, dateFin, dateDebut, accompagnements];
}
