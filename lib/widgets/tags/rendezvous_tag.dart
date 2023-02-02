import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';

class RendezvousTag extends StatelessWidget {
  const RendezvousTag(this.tag, this.isGreenTag, {Key? key}) : super(key: key);

  final String tag;
  final bool isGreenTag;

  @override
  Widget build(BuildContext context) {
    return JobTag(
      label: tag,
      backgroundColor: isGreenTag ? AppColors.accent3Lighten : AppColors.accent2Lighten,
    );
  }
}
