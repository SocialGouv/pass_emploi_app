import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/not_up_to_date_message.dart';

class ReloadablePage extends StatelessWidget {
  final String emptyMessage;
  final String reloadMessage;
  final Function() onReload;
  const ReloadablePage({required this.emptyMessage, required this.reloadMessage, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Margins.spacing_base),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
          child: NotUpToDateMessage(message: reloadMessage, onRefresh: onReload),
        ),
        SizedBox(height: Margins.spacing_base),
        Expanded(child: Text(emptyMessage, style: TextStyles.textBaseRegular, textAlign: TextAlign.center)),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}
