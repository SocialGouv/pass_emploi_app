import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/debounce_text_form_field.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/full_screen_text_form_field_scaffold.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/multiline_app_bar.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/utils/read_only_text_form_field.dart';

const _heroTag = 'keyword';

class KeywordTextFormField extends StatefulWidget {
  final String title;
  final String hint;
  final Function(String? keyword) onKeywordSelected;
  final String? initialValue;

  const KeywordTextFormField({
    required this.title,
    required this.hint,
    required this.onKeywordSelected,
    this.initialValue,
  });

  @override
  State<KeywordTextFormField> createState() => _KeywordTextFormFieldState();
}

class _KeywordTextFormFieldState extends State<KeywordTextFormField> {
  String? _selectedKeyword;

  @override
  void initState() {
    _selectedKeyword = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ReadOnlyTextFormField(
      title: widget.title,
      hint: widget.hint,
      heroTag: _heroTag,
      textFormFieldKey: Key(_selectedKeyword.toString()),
      withDeleteButton: _selectedKeyword != null,
      onTextTap: () => Navigator.push(
        context,
        _KeywordTextFormFieldPage.materialPageRoute(
          title: widget.title,
          hint: widget.hint,
          selectedKeyword: _selectedKeyword,
        ),
      ).then((keyword) => _updateKeyword(keyword)),
      onDeleteTap: () => _updateKeyword(null),
      initialValue: _selectedKeyword,
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
    return FullScreenTextFormFieldScaffold(
      body: Column(
        children: [
          MultilineAppBar(
            title: title,
            hint: hint,
            onCloseButtonPressed: () => Navigator.pop(context, selectedKeyword),
          ),
          DebounceTextFormField(
            heroTag: _heroTag,
            initialValue: selectedKeyword,
            onFieldSubmitted: (keyword) => Navigator.pop(context, keyword),
          ),
        ],
      ),
    );
  }
}
