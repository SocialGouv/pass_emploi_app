import 'package:equatable/equatable.dart';

class RecherchesDerniersMotsClesState extends Equatable {
  final List<String> motsCles;

  const RecherchesDerniersMotsClesState({this.motsCles = const []});

  @override
  List<Object?> get props => [motsCles];
}
