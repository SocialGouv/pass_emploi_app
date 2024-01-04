import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/text_form_fields/base_text_form_field.dart';

class DatePicker extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BaseTextField(
      enabled: isActiveDate,
      keyboardType: TextInputType.none,
      onTap: () => openDatePicker(context),
      showCursor: false,
      readOnly: true,
      prefixIcon: IconButton(
        onPressed: () => openDatePicker(context),
        tooltip: Strings.selectDateTooltip,
        icon: Icon(AppIcons.today_rounded, color: AppColors.grey800),
      ),
      suffixIcon: onDateDeleted != null && initialDateValue != null
          ? IconButton(
              onPressed: onDateDeleted,
              tooltip: Strings.removeDateTooltip,
              icon: Icon(AppIcons.cancel_rounded, color: AppColors.grey800),
            )
          : null,
      hintText: _hintText(),
      errorText: errorText,
    );
  }

  Future<void> openDatePicker(BuildContext context) =>
      Platform.isIOS ? _iOSDatePicker(context) : _androidDatePicker(context);

  Future<void> _iOSDatePicker(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 190,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                  initialDateTime: initialDateValue ?? DateTime.now(),
                  minimumDate: firstDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) {
                    onDateSelected(value);
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
      firstDate: firstDate ?? DateTime(2020),
      lastDate: DateTime(2101),
      initialDate: initialDateValue ?? DateTime.now(),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null && picked != initialDateValue) {
      onDateSelected(picked);
    }
  }

  String _hintText() {
    if (showInitialDate) return initialDateValue != null ? initialDateValue!.toDay() : '';
    return '';
  }
}
