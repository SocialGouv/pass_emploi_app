import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionStatusGroup extends StatefulWidget {
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
  State<UserActionStatusGroup> createState() => _UserActionStatusGroupState();
}

class _UserActionStatusGroupState extends State<UserActionStatusGroup> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        UserActionStatusButton(
          label: Strings.actionToDo,
          onPressed: widget.isEnabled ? () => {widget.update(UserActionStatus.NOT_STARTED)} : null,
          isSelected: widget.status == UserActionStatus.NOT_STARTED,
        ),
        UserActionStatusButton(
          label: Strings.actionInProgress,
          onPressed: widget.isEnabled ? () => widget.update(UserActionStatus.IN_PROGRESS) : null,
          isSelected: widget.status == UserActionStatus.IN_PROGRESS,
        ),
        Stack(
          children: [
            Center(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ),
            UserActionStatusButton(
              label: Strings.actionDone,
              onPressed: widget.isEnabled
                  ? () {
                      _confettiController.play();
                      widget.update(UserActionStatus.DONE);
                    }
                  : null,
              isSelected: widget.status == UserActionStatus.DONE,
            ),
          ],
        ),
        if (!widget.isCreated)
          UserActionStatusButton(
            label: Strings.actionCanceled,
            onPressed: widget.isEnabled ? () => widget.update(UserActionStatus.CANCELED) : null,
            isSelected: widget.status == UserActionStatus.CANCELED,
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
