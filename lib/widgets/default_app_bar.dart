import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DefaultAppBar extends AppBar {
  DefaultAppBar({Widget? title, List<Widget>? actions, bool? centerTitle})
      : super(
          title: title,
          actions: actions,
          centerTitle: centerTitle,
          iconTheme: IconThemeData(color: AppColors.contentColor),
          toolbarHeight: Dimens.appBarHeight,
          backgroundColor: Colors.transparent,
          elevation: 2,
        );
}

class FlatDefaultAppBar extends AppBar {
  FlatDefaultAppBar({
    Widget? title,
    Widget? leading,
    PreferredSizeWidget? bottom,
    List<Widget>? actions,
    bool? centerTitle = true,
    Color? backgroundColor,
    bool automaticallyImplyLeading = true,
  }) : super(
          title: title,
          centerTitle: centerTitle,
          actions: actions,
          iconTheme: IconThemeData(color: AppColors.contentColor),
          toolbarHeight: Dimens.flatAppBarHeight,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: leading,
          bottom: bottom,
          automaticallyImplyLeading: automaticallyImplyLeading,
        );
}

FlatDefaultAppBar passEmploiAppBar(
    {required String? label, required BuildContext context, bool withBackButton = false}) {
  final store = StoreProvider.of<AppState>(context);
  if (store.state.demoState) {
    return FlatDefaultAppBar(
      title: _ModeDemoPlaceholder(),
      automaticallyImplyLeading: false,
      bottom: label != null
          ? FlatDefaultAppBar(
              title: Text(label, style: TextStyles.textAppBar),
              leading: withBackButton ? _appBarLeading : null,
            )
          : null,
    );
  }
  return FlatDefaultAppBar(
    title: label != null ? Text(label, style: TextStyles.textAppBar) : null,
    leading: withBackButton ? _appBarLeading : null,
  );
}

Widget _appBarLeading = Builder(
  builder: (BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Drawables.icChevronLeft,
        color: AppColors.contentColor,
        height: Margins.spacing_xl,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  },
);

class _ModeDemoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(color: AppColors.warningLighten, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              Drawables.icInfo,
              color: AppColors.warning,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  Strings.modeDemoAppBarLabel,
                  style: TextStyles.textBaseBoldWithColor(AppColors.warning),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
