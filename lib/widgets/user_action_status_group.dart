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

  const UserActionStatusGroup({
    required this.status,
    required this.update,
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
          label: Strings.actionToDo,
          onPressed: isEnabled ? () => {update(UserActionStatus.NOT_STARTED)} : null,
          isSelected: status == UserActionStatus.NOT_STARTED,
        ),
        UserActionStatusButton(
          label: Strings.actionInProgress,
          onPressed: isEnabled ? () => update(UserActionStatus.IN_PROGRESS) : null,
          isSelected: status == UserActionStatus.IN_PROGRESS,
        ),
        UserActionStatusButton(
          label: Strings.actionDone,
          onPressed: isEnabled ? () => update(UserActionStatus.DONE) : null,
          isSelected: status == UserActionStatus.DONE,
        ),
        if (!isCreated)
          UserActionStatusButton(
            label: Strings.actionCanceled,
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
    required this.isSelected,
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

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
