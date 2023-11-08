import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';

class CardActions extends StatelessWidget {
  const CardActions({required this.actions});
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: actionsBuilder(actions),
    );
  }

  List<Widget> actionsBuilder(List<Widget> actions) {
    final List<Widget> result = [];
    for (var i = 0; i < actions.length; i++) {
      result.add(Expanded(child: actions[i]));
      if (i < actions.length - 1) {
        result.add(SizedBox(width: Margins.spacing_base));
      }
    }
    return result;
  }
}
