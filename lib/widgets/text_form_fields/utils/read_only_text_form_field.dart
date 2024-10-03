import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class ReadOnlyTextFormField extends StatefulWidget {
  final String title;
  final String heroTag;
  final Key textFormFieldKey;
  final bool withDeleteButton;
  final Function() onTextTap;
  final Function() onDeleteTap;
  final String a11ySuppressionLabel;
  final String hint;
  final String? initialValue;
  final Widget? prefixIcon;

  const ReadOnlyTextFormField({
    super.key,
    required this.title,
    required this.heroTag,
    required this.textFormFieldKey,
    required this.withDeleteButton,
    required this.onTextTap,
    required this.onDeleteTap,
    required this.a11ySuppressionLabel,
    required this.hint,
    this.initialValue,
    this.prefixIcon,
  });

  @override
  State<ReadOnlyTextFormField> createState() => _ReadOnlyTextFormFieldState();
}

class _ReadOnlyTextFormFieldState extends State<ReadOnlyTextFormField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(onKeyEvent: (node, event) {
      if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
        widget.onTextTap();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(widget.title, style: TextStyles.textBaseBold)),
        Semantics(
          excludeSemantics: true,
          child: Text(widget.hint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
        ),
        SizedBox(height: Margins.spacing_base),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Hero(
              tag: widget.heroTag,
              child: Semantics(
                button: true,
                label: widget.initialValue != null ? "${Strings.chosenValue} ${widget.initialValue!}" : widget.hint,
                child: Material(
                  type: MaterialType.transparency,
                  child: BaseTextField(
                    focusNode: _focusNode,
                    key: widget.textFormFieldKey,
                    readOnly: true,
                    prefixIcon: widget.prefixIcon,
                    initialValue: widget.initialValue,
                    onTap: widget.onTextTap,
                  ),
                ),
              ),
            ),
            if (widget.withDeleteButton)
              IconButton(
                onPressed: widget.onDeleteTap,
                tooltip: widget.a11ySuppressionLabel,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ],
    );
  }
}
