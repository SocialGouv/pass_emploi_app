import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/ignore_tracking_context_provider.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/keyword_text_form_field_page.dart';
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
    return Semantics(
      button: true,
      child: ReadOnlyTextFormField(
        title: widget.title,
        hint: widget.hint,
        heroTag: _heroTag,
        textFormFieldKey: Key(_selectedKeyword.toString()),
        withDeleteButton: _selectedKeyword != null,
        onTextTap: () => Navigator.push(
          IgnoreTrackingContext.of(context).nonTrackingContext,
          KeywordTextFormFieldPage.materialPageRoute(
            heroTag: _heroTag,
            title: widget.title,
            hint: widget.hint,
            selectedKeyword: _selectedKeyword,
          ),
        ).then((keyword) => _updateKeyword(keyword)),
        onDeleteTap: () => _updateKeyword(null),
        initialValue: _selectedKeyword,
      ),
    );
  }

  void _updateKeyword(String? keyword) {
    setState(() => _selectedKeyword = keyword);
    widget.onKeywordSelected(keyword);
  }
}
