import 'package:flutter/material.dart';
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
              Checkbox(
                value: action.isDone,
                onChanged: null,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  action.content,
                  style: TextStyles.textSmRegular,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
