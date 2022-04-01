import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_view_model.dart';

class StatutTagPE extends StatelessWidget {
  final UserActionPETagViewModel viewModel;

  const StatutTagPE({required this.viewModel}) : super();

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