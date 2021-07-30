import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class ActionWidget extends StatelessWidget {
  final UserAction action;
  final GestureTapCallback onTap;
  final Color borderColor;

  ActionWidget({required this.action, required this.onTap, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          onTap: onTap,
          child: Row(
            children: [
              if (!action.isDone)
                Padding(
                  padding: const EdgeInsets.only(left: 17.75, right: 13.75),
                  child: SvgPicture.asset("assets/ic_grey_circle.svg"),
                ),
              if (action.isDone)
                Padding(
                  padding: const EdgeInsets.only(left: 17.75, right: 13.75),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SvgPicture.asset("assets/ic_night_blue_circle.svg"),
                      SvgPicture.asset("assets/ic_green_check.svg"),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                  child: Text(
                    action.content,
                    style: TextStyles.textSmRegular,
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
