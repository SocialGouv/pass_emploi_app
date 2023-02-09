import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class KeywordTextFormField extends StatefulWidget {
  final String title;
  final String hint;
  final Function(String? keyword) onKeywordSelected;

  const KeywordTextFormField({
    required this.title,
    required this.hint,
    required this.onKeywordSelected,
  });

  @override
  State<KeywordTextFormField> createState() => _KeywordTextFormFieldState();
}

class _KeywordTextFormFieldState extends State<KeywordTextFormField> {
  String? _selectedKeyword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: TextStyles.textBaseBold),
            Text(widget.hint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          ],
        ),
        SizedBox(height: Margins.spacing_base),
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Hero(
              tag: 'keyword',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  key: Key(_selectedKeyword.toString()),
                  style: TextStyles.textBaseBold,
                  decoration: _inputDecoration(),
                  readOnly: true,
                  initialValue: _selectedKeyword,
                  onTap: () => Navigator.push(
                    context,
                    _KeywordTextFormFieldPage.materialPageRoute(
                      title: widget.title,
                      hint: widget.hint,
                      selectedKeyword: _selectedKeyword,
                    ),
                  ).then((location) => _updateKeyword(location)),
                ),
              ),
            ),
            if (_selectedKeyword != null)
              IconButton(
                onPressed: () => _updateKeyword(null),
                tooltip: Strings.suppressionLabel,
                icon: const Icon(Icons.close),
              ),
          ],
        ),
      ],
    );
  }

  void _updateKeyword(String? keyword) {
    setState(() => _selectedKeyword = keyword);
    widget.onKeywordSelected(keyword);
  }
}

class _KeywordTextFormFieldPage extends StatelessWidget {
  final String title;
  final String hint;
  final String? selectedKeyword;

  _KeywordTextFormFieldPage({required this.title, required this.hint, this.selectedKeyword});

  static MaterialPageRoute<String?> materialPageRoute({
    required String title,
    required String hint,
    required String? selectedKeyword,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => _KeywordTextFormFieldPage(
        title: title,
        hint: hint,
        selectedKeyword: selectedKeyword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _builder(context);
  }

  Widget _builder(BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      // Required to delegate top padding to system
      appBar: AppBar(toolbarHeight: 0, scrolledUnderElevation: 0),
      body: Column(
        children: [
          _FakeAppBar(title: title, hint: hint, onCloseButtonPressed: () => Navigator.pop(context, selectedKeyword)),
          Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Hero(
              tag: 'keyword',
              child: Material(
                type: MaterialType.transparency,
                child: TextFormField(
                  style: TextStyles.textBaseBold,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
                  initialValue: selectedKeyword,
                  decoration: _inputDecoration(),
                  autofocus: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeAppBar extends StatelessWidget {
  final String title;
  final String hint;
  final VoidCallback onCloseButtonPressed;

  const _FakeAppBar({required this.title, required this.hint, required this.onCloseButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: kToolbarHeight, height: kToolbarHeight),
          child: IconButton(
            onPressed: onCloseButtonPressed,
            tooltip: Strings.close,
            icon: const Icon(Icons.close),
          ),
        ),
        SizedBox(width: Margins.spacing_base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.textBaseBold),
              Text(hint, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
            ],
          ),
        )
      ],
    );
  }
}

InputDecoration _inputDecoration() {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(
      left: Margins.spacing_base,
      right: Margins.spacing_xl,
      top: Margins.spacing_base,
      bottom: Margins.spacing_base,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColors.contentColor, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: AppColors.primary, width: 1.0),
    ),
  );
}
