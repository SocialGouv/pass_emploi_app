import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
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
  final bool showInitialDate;
  final String? errorText;

  DatePicker({
    required this.onDateSelected,
    required this.initialDateValue,
    required this.isActiveDate,
    this.onDateDeleted,
    this.firstDate,
    this.showInitialDate = true,
    this.errorText,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final dateGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
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
    );
  }

  Future<void> openDatePicker(BuildContext context) =>
      Platform.isIOS ? _iOSDatePicker(context) : _androidDatePicker(context);

  Future<void> _iOSDatePicker(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300,
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  Strings.close,
                  style: TextStyles.textSecondaryButton,
                ),
              ),
            ),
            Flexible(
              child: CupertinoDatePicker(
                  initialDateTime: widget.initialDateValue ?? DateTime.now(),
                  minimumDate: widget.firstDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) {
                    widget.onDateSelected(value);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _androidDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime(2020),
      lastDate: DateTime(2101),
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
