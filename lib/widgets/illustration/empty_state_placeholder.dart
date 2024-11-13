import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';

class EmptyStatePlaceholder extends StatelessWidget {
  const EmptyStatePlaceholder({
    super.key,
    required this.illustration,
    this.title,
    this.subtitle,
    this.action,
  });

  final Illustration illustration;
  final String? title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(Margins.spacing_m),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (constraints.maxHeight > 200) ...[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 130, maxWidth: 130),
                    child: illustration,
                  ),
                  SizedBox(height: Margins.spacing_xl),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyles.textBaseBold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Margins.spacing_base),
                ],
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyles.textBaseRegular,
                    textAlign: TextAlign.center,
                  ),
                if (action != null) ...[
                  SizedBox(height: Margins.spacing_m),
                  action!,
                ]
              ],
            ),
          ),
        );
      }),
    );
  }
}
