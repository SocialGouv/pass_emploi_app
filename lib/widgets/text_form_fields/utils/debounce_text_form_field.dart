import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/utils/debouncer.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class DebounceTextFormField extends StatelessWidget {
  final String heroTag;
  final String? initialValue;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;
  final Debouncer _debouncer = Debouncer(duration: Duration(milliseconds: 200));

  DebounceTextFormField({
    required this.heroTag,
    required this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: BaseTextField(
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onFieldSubmitted,
            initialValue: initialValue,
            autofocus: true,
            onChanged: (value) {
              if (onChanged != null) _debouncer.run(() => onChanged!(value));
            },
          ),
        ),
      ),
    );
  }
}
