import 'package:equatable/equatable.dart';

class CallToAction extends Equatable {
  final String label;
  final Uri uri;
  final String? drawableId;

  CallToAction(this.label, this.uri, {this.drawableId});

  @override
  List<Object?> get props => [label, uri.toString(), drawableId];
}
