import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/accessibility_utils.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function()? onDateDeleted;
  final DateTime? initialDateValue;
  final bool isActiveDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool showInitialDate;
  final String? errorText;
  final bool isInvalid;

  DatePicker({
    required this.onDateSelected,
    required this.initialDateValue,
    required this.isActiveDate,
    this.onDateDeleted,
    this.firstDate,
    this.lastDate,
    this.showInitialDate = true,
    this.errorText,
    this.isInvalid = false,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final dateGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.initialDateValue == null ? Strings.emptyDate : null,
      child: BaseTextField(
        enabled: widget.isActiveDate,
        keyboardType: TextInputType.none,
        onTap: () => openDatePicker(context),
        showCursor: false,
        readOnly: true,
        prefixIcon: IconButton(
          key: dateGlobalKey,
          onPressed: () => openDatePicker(context),
          tooltip: Strings.selectDateTooltip,
          icon: Icon(AppIcons.today_rounded, color: AppColors.grey800),
        ),
        suffixIcon: widget.onDateDeleted != null && widget.initialDateValue != null
            ? IconButton(
                onPressed: () {
                  dateGlobalKey.requestFocusDelayed();
                  widget.onDateDeleted?.call();
                },
                tooltip: Strings.removeDateTooltip,
                icon: Icon(AppIcons.cancel_rounded, color: AppColors.grey800),
              )
            : null,
        hintText: _hintText(context),
        errorText: widget.errorText,
        isInvalid: widget.isInvalid,
      ),
    );
  }

  Future<void> openDatePicker(BuildContext context) => datePicker(context);

  Future<void> datePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: widget.lastDate ?? DateTime(2101),
      initialDate: widget.initialDateValue ?? DateTime.now(),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != widget.initialDateValue) {
      widget.onDateSelected(picked);
    }
  }

  String _hintText(BuildContext context) {
    if (widget.showInitialDate) {
      if (widget.initialDateValue == null) return '';
      if (A11yUtils.withScreenReader(context)) return widget.initialDateValue!.toDayWithFullMonth();
      return widget.initialDateValue!.toDay();
    }
    return '';
  }
}
