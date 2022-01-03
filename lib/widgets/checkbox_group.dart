import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CheckBoxGroup extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(List<String> selectedOptions) onSelectedOptionsUpdated;

  const CheckBoxGroup({
    Key? key,
    required this.title,
    required this.options,
    required this.onSelectedOptionsUpdated,
  }) : super(key: key);

  @override
  _CheckBoxGroupState createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState extends State<CheckBoxGroup> {
  late Map<String, bool> _optionsSelectionStatus;

  @override
  void initState() {
    super.initState();
    _optionsSelectionStatus = Map.fromEntries(widget.options.map((e) => MapEntry(e, false)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(widget.title, style: TextStyles.textMdMedium),
          ),
          SizedBox(height: 12),
          ..._optionsSelectionStatus.entries.map<Widget>((entry) => _createCheckBox(entry.key, entry.value)).toList()
        ],
    );
  }

  Widget _createCheckBox(String key, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CheckboxListTile(
        title: Text(key, style: TextStyles.textMdRegular),
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value != null) {
              _optionsSelectionStatus[key] = value;
              widget.onSelectedOptionsUpdated(_listOfSelectedOptions());
            }
          });
        },
      ),
    );
  }

  List<String> _listOfSelectedOptions() =>
      _optionsSelectionStatus.entries.where((element) => element.value).map((e) => e.key).toList();
}
