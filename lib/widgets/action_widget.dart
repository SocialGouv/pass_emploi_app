import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class ActionWidget extends StatelessWidget {
  final UserAction action;
  final GestureTapCallback onTap;

  ActionWidget({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: AppColors.borderGrey),
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
              Text(action.content),
            ],
          ),
        ),
      ),
    );
  }
}
