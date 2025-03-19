import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PassEmploiRadio<T> extends StatelessWidget {
  const PassEmploiRadio({
    super.key,
    required this.onPressed,
    required this.value,
    required this.groupValue,
    required this.title,
  });

  final void Function(T?) onPressed;
  final T value;
  final T groupValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "${value == groupValue ? Strings.selectedRadioButton : Strings.unselectedRadioButton} : $title",
      child: InkWell(
        onTap: () => onPressed(value),
        child: Semantics(
          excludeSemantics: true,
          child: Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                // a11y : ingonre pointer to not take priority on semantic focus
                child: IgnorePointer(
                  child: Radio<T>(
                    value: value,
                    groupValue: groupValue,
                    onChanged: (value) => onPressed(value),
                  ),
                ),
              ),
              Flexible(
                child: Semantics(
                  child: Text(title, style: TextStyles.textBaseRegular),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
