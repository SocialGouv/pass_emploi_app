import 'package:equatable/equatable.dart';

class CallToAction extends Equatable {
  final String label;
  final Uri uri;
  final String? drawableRes;

  CallToAction(this.label, this.uri, {this.drawableRes});

  @override
  List<Object?> get props => [label, uri.toString(), drawableRes];
}
