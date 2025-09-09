import 'package:equatable/equatable.dart';

class FtIaTutorialState extends Equatable {
  final bool shouldShow;

  FtIaTutorialState(this.shouldShow);

  @override
  List<Object?> get props => [shouldShow];
}
