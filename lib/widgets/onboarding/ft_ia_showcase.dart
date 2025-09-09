import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/ft_ia_tutorial/ft_ia_tutorial_actions.dart';
import 'package:pass_emploi_app/presentation/ft_ia_tutorial_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:showcaseview/showcaseview.dart';

class FtIaShowcaseWrapper extends StatelessWidget {
  const FtIaShowcaseWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, __) {},
      onFinish: () {
        StoreProvider.of<AppState>(context).dispatch(FtIaTutorialSeenAction());
      },
      builder: (context) {
        return child;
      },
    );
  }
}

class FtIaShowcase extends StatefulWidget {
  const FtIaShowcase({super.key, required this.child});
  final Widget child;

  @override
  State<FtIaShowcase> createState() => _FtIaShowcaseState();
}

class _FtIaShowcaseState extends State<FtIaShowcase> {
  final GlobalKey key = GlobalKey();

  bool shown = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FtIaTutorialViewModel>(
      converter: (store) => FtIaTutorialViewModel.create(store),
      builder: (context, vm) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.isVisible && !shown) {
            ShowCaseWidget.of(context).startShowCase([key]);
            shown = true;
          }
        });
        return Showcase(
          targetBorderRadius: BorderRadius.circular(Dimens.radius_base),
          tooltipPosition: TooltipPosition.top,
          title: Strings.iaFtShowcaseTitle,
          description: null,
          tooltipBackgroundColor: Colors.white,
          titleTextStyle: TextStyles.textMBold.copyWith(color: AppColors.primary),
          descTextStyle: TextStyles.textBaseRegular.copyWith(color: AppColors.primary),
          key: key,
          titleAlignment: Alignment.centerLeft,
          descriptionAlignment: Alignment.centerLeft,
          tooltipPadding: const EdgeInsets.all(Margins.spacing_base),
          child: widget.child,
        );
      },
    );
  }
}
