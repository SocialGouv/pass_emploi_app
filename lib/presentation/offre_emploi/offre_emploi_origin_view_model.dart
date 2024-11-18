import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/image_path.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class OffreEmploiOriginViewModel extends Equatable {
  final String name;
  final ImagePath imagePath;

  OffreEmploiOriginViewModel(this.name, this.imagePath);

  static OffreEmploiOriginViewModel? from(Origin? origin) {
    return switch (origin) {
      final PartenaireOrigin origin => OffreEmploiOriginViewModel(origin.name, NetworkImagePath(origin.logoUrl)),
      FranceTravailOrigin() => OffreEmploiOriginViewModel(
          Strings.franceTravail,
          AssetsImagePath(Drawables.franceTravailLogo),
        ),
      null => null,
    };
  }

  @override
  List<Object?> get props => [name, imagePath];
}
