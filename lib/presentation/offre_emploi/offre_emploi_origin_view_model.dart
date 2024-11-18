import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/image_source.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class OffreEmploiOriginViewModel extends Equatable {
  final String name;
  final ImageSource source;

  OffreEmploiOriginViewModel(this.name, this.source);

  static OffreEmploiOriginViewModel? from(Origin? origin) {
    return switch (origin) {
      final PartenaireOrigin origin => OffreEmploiOriginViewModel(origin.name, NetworkImageSource(origin.logoUrl)),
      FranceTravailOrigin() => OffreEmploiOriginViewModel(
          Strings.franceTravail,
          AssetsImageSource(Drawables.franceTravailLogo),
        ),
      null => null,
    };
  }

  @override
  List<Object?> get props => [name, source];
}
