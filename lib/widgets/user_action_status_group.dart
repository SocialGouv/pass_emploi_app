import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionStatusGroup extends StatefulWidget {
  final bool isInitiallyDone;

  const UserActionStatusGroup({required this.isInitiallyDone}) : super();

  @override
  _UserActionStatusGroupState createState() => _UserActionStatusGroupState();
}

class _UserActionStatusGroupState extends State<UserActionStatusGroup> {
  late bool isDone;

  @override
  void initState() {
    super.initState();
    update(isNowDone: widget.isInitiallyDone);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: UserActionStatusButton(
            label: Strings.actionToDo,
            onPressed: () => update(isNowDone: false),
            isSelected: isDone,
          ),
        ),
        UserActionStatusButton(
          label: Strings.actionDone,
          onPressed: () => update(isNowDone: true),
          isSelected: !isDone,
        ),
      ],
    );
  }

  update({required bool isNowDone}) {
    setState(() {
      isDone = isNowDone;
    });
  }
}

enum UserActionStatus { TODO, IN_PROGRESS, DONE }

class UserActionStatusButton extends StatelessWidget {
  final VoidCallback onPressed;
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
        padding: const EdgeInsets.all(16.0),
        child: Text(label, style: _textStyle()),
      ),
    );
  }

  Color _borderColor() => isSelected ? AppColors.nightBlue : AppColors.bluePurpleAlpha20;

  double _borderWidth() => isSelected ? 2 : 1;

  TextStyle _textStyle() => isSelected ? TextStyles.textSmMedium() : TextStyles.textSmRegular();

  Color _backgroundColor() => isSelected ? AppColors.nightBlueAlpha05 : Colors.transparent;
}
