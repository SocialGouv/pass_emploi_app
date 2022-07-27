import 'package:equatable/equatable.dart';

class FormattedText extends Equatable {
  final String value;
  final bool bold;

  FormattedText(this.value, {this.bold = false});

  @override
  List<Object?> get props => [value, bold];
}
