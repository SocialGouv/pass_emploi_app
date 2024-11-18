import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/image_path.dart';

class OffreEmploiOriginViewModel extends Equatable {
  final String name;
  final ImagePath imagePath;

  OffreEmploiOriginViewModel(this.name, this.imagePath);

  @override
  List<Object?> get props => [name, imagePath];
}
