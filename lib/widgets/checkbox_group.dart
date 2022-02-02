import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/checkbox_value_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/help_tooltip.dart';

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
        Text(widget.title, style: TextStyles.textBaseBold),
        SizedBox(height: Margins.spacing_base),
        Container(
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16)), boxShadow: [
            Shadows.boxShadow,
          ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _optionsSelectionStatus.entries
                  .map<Widget>((entry) => _createCheckBox(entry.key, entry.value))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _createCheckBox(T viewModel, bool isSelected) {
    final label = viewModel.label;
    final helpText = viewModel.helpText;
    return CheckboxListTile(
      title: helpText != null ? _textWithToolTip(label, helpText) : _title(label),
      value: isSelected,
      activeColor: AppColors.primary,
      onChanged: (value) {
        setState(() {
          if (value != null) {
            _optionsSelectionStatus[viewModel] = value;
            var listOfSelectedOptions = _listOfSelectedOptions();
            widget.onSelectedOptionsUpdated(listOfSelectedOptions);
          }
        });
      },
    );
  }

  Widget _textWithToolTip(String label, String helpText) {
    return Row(
      children: [
        _title(label),
        SizedBox(width: Margins.spacing_s),
        HelpTooltip(
          message: helpText,
          iconRes: Drawables.icInfo,
        )
      ],
    );
  }

  Widget _title(String label) => Text(label, style: TextStyles.textBaseRegular);

  List<T> _listOfSelectedOptions() =>
      _optionsSelectionStatus.entries.where((element) => element.value).map((e) => e.key).toList();
}
