import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class StatutTag extends StatelessWidget {
  final UserActionTagViewModel viewModel;

  const StatutTag({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: viewModel.backgroundColor,
        border: Border.all(color: viewModel.textColor),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Text(
        viewModel.title,
        style: TextStyles.textSRegularWithColor(viewModel.textColor),
      ),
    );
  }
}