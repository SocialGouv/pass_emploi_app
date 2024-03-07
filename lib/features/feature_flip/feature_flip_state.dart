import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/feature_flip.dart';

class FeatureFlipState extends Equatable {
  final FeatureFlip featureFlip;

  FeatureFlipState(this.featureFlip);

  @override
  List<Object?> get props => [featureFlip];
}
