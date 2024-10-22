import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class AlertMessageRetry {
  final String message;
  final void Function() onRetry;
  final bool link;

  AlertMessageRetry({required this.message, required this.onRetry, this.link = false});
}

class AlertMessage extends StatelessWidget {
  const AlertMessage({required this.message, this.retryMessage});

  final String message;
  final AlertMessageRetry? retryMessage;

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.warning;
    return CardContainer(
      backgroundColor: AppColors.warningLighten,
      withShadow: false,
      padding: EdgeInsets.symmetric(
        vertical: Margins.spacing_base,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: Margins.spacing_base),
              Icon(AppIcons.error_rounded, color: contentColor),
              SizedBox(width: Margins.spacing_s),
              Expanded(child: Text(message, style: TextStyles.textSMedium(color: contentColor))),
              SizedBox(width: Margins.spacing_base),
            ],
          ),
          if (retryMessage != null)
            Align(
              alignment: Alignment.centerRight,
              child: Semantics(
                container: true,
                child: TextButton(
                  onPressed: retryMessage!.onRetry,
                  child: Semantics(
                    link: retryMessage!.link ? true : null,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          if (retryMessage!.link) ...[
                            WidgetSpan(
                              child: Icon(
                                AppIcons.open_in_new_rounded,
                                color: contentColor,
                                size: Dimens.icon_size_base,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: Margins.spacing_xs)),
                          ],
                          TextSpan(text: retryMessage!.message, style: TextStyles.textSBoldWithColor(contentColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
