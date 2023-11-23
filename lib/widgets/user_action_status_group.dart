import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionStatusGroup extends StatelessWidget {
  final UserActionStatus status;
  final bool isCreated;
  final bool isEnabled;
  final Function(UserActionStatus newStatus) update;
  final VoidCallback onActionDone;

  const UserActionStatusGroup({
    required this.status,
    required this.update,
    required this.onActionDone,
    this.isCreated = false,
    this.isEnabled = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        UserActionStatusButton(
          label: Strings.todoPillule,
          onPressed: isEnabled ? () => {update(UserActionStatus.NOT_STARTED)} : null,
          isSelected: status == UserActionStatus.NOT_STARTED,
        ),
        UserActionStatusButton(
          label: Strings.doingPillule,
          onPressed: isEnabled ? () => update(UserActionStatus.IN_PROGRESS) : null,
          isSelected: status == UserActionStatus.IN_PROGRESS,
        ),
        UserActionStatusButton(
          label: Strings.donePillule,
          onPressed: isEnabled
              ? () {
                  onActionDone();
                  update(UserActionStatus.DONE);
                }
              : null,
          isSelected: status == UserActionStatus.DONE,
        ),
        if (!isCreated)
          UserActionStatusButton(
            label: Strings.canceledPillule,
            onPressed: isEnabled ? () => update(UserActionStatus.CANCELED) : null,
            isSelected: status == UserActionStatus.CANCELED,
          ),
      ],
    );
  }
}

class UserActionStatusButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSelected;

  const UserActionStatusButton({
    super.key,
    required this.isSelected,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: _borderColor(), width: _borderWidth()),
          backgroundColor: _backgroundColor()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(label, style: _textStyle()),
      ),
    );
  }

  Color _borderColor() => isSelected ? AppColors.nightBlue : AppColors.bluePurpleAlpha20;

  double _borderWidth() => isSelected ? 2 : 1;

  TextStyle _textStyle() => isSelected ? TextStyles.textSMedium() : TextStyles.textSRegular();

  Color _backgroundColor() => isSelected ? AppColors.nightBlueAlpha05 : Colors.transparent;
}
