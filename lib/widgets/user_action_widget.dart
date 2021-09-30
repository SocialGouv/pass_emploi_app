import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionWidget extends StatelessWidget {
  final UserActionViewModel action;
  final GestureTapCallback onTap;

  UserActionWidget({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: action.isDone ? AppColors.nightBlue : Colors.white,
          border: Border.all(width: 1, color: AppColors.nightBlue),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 17.75,
                  right: 13.75,
                  top: 16,
                  bottom: 16,
                ),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    if (!action.isDone) SvgPicture.asset("assets/ic_night_blue_circle.svg"),
                    if (action.isDone) SvgPicture.asset("assets/ic_white_circle.svg"),
                    if (action.isDone)
                      Padding(
                        padding: const EdgeInsets.only(left: 1),
                        child: SvgPicture.asset("assets/ic_white_check.svg"),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.content,
                        style: TextStyles.textSmRegular(color: action.isDone ? Colors.white : AppColors.nightBlue),
                      ),
                      SizedBox(height: 4),
                      if (action.withComment)
                        Text(
                          action.comment,
                          style: TextStyles.textXsRegular(color: action.isDone ? Colors.white : AppColors.nightBlue),
                        ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
