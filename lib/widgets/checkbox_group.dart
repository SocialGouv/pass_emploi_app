import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CheckBoxGroup<T> extends StatefulWidget {
  final String title;
  final List<CheckboxValueViewModel<T>> options;
  final void Function(List<CheckboxValueViewModel> selectedOptions) onSelectedOptionsUpdated;

  const CheckBoxGroup({
    Key? key,
    required this.title,
    required this.options,
    required this.onSelectedOptionsUpdated,
  }) : super(key: key);

  @override
  _CheckBoxGroupState<CheckboxValueViewModel<T>> createState() => _CheckBoxGroupState();
}

class _CheckBoxGroupState<T extends CheckboxValueViewModel> extends State<CheckBoxGroup> {
  late Map<T, bool> _optionsSelectionStatus;

  @override
  void initState() {
    super.initState();
    _optionsSelectionStatus = Map.fromEntries(widget.options.map((e) => MapEntry(e as T, e.isInitiallyChecked)));
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

  Widget _createCheckBox(T viewModel, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CheckboxListTile(
        title: Text(viewModel.label, style: TextStyles.textMdRegular),
        value: isSelected,
        onChanged: (value) {
          setState(() {
            if (value != null) {
              _optionsSelectionStatus[viewModel] = value;
              var listOfSelectedOptions = _listOfSelectedOptions();
              widget.onSelectedOptionsUpdated(listOfSelectedOptions);
            }
          });
        },
      ),
    );
  }

  List<T> _listOfSelectedOptions() =>
      _optionsSelectionStatus.entries.where((element) => element.value).map((e) => e.key).toList();
}
