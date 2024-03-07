import 'package:equatable/equatable.dart';

class FeatureFlip extends Equatable {
  final bool useCvm;

  FeatureFlip({required this.useCvm});

  factory FeatureFlip.initial() {
    return FeatureFlip(useCvm: false);
  }

  FeatureFlip copyWith({bool? useCvm}) {
    return FeatureFlip(
      useCvm: useCvm ?? this.useCvm,
    );
  }

  @override
  List<Object?> get props => [useCvm];
}
