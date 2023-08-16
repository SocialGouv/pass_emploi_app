import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/widgets/illustration/empty_state_placeholder.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class Empty extends StatelessWidget {
  final String description;

  const Empty({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyStatePlaceholder(
        illustration: Illustration.grey(AppIcons.checklist_rounded, withWhiteBackground: true),
        title: description,
      ),
    );
  }
}
