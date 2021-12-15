import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class PlusPage extends TraceableStatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      appBar: FlatDefaultAppBar(
        title: Text(Strings.menuPlus, style: TextStyles.h3Semi),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: primaryActionButton(
                      onPressed: () => debugPrint("Clicked !!"),
                      label: Strings.logoutAction,
                      textColor: AppColors.franceRed,
                      backgroundColor: AppColors.franceRedAlpha05,
                      disabledBackgroundColor: AppColors.redGrey,
                      rippleColor: AppColors.redGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
