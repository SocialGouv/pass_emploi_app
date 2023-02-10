import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';

class TextFormFieldInputDecoration extends InputDecoration {
  TextFormFieldInputDecoration()
      : super(
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
