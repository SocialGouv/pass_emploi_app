import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class LoaderPage extends StatefulWidget {
  final double _logoHeight = 89.0;
  final double _screenHeight;

  LoaderPage({required double screenHeight}) : _screenHeight = screenHeight;

  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with SingleTickerProviderStateMixin {
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _logoAnimation = Tween<double>(
      begin: widget._screenHeight / 2 - widget._logoHeight / 2,
      end: widget._screenHeight / 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              top: widget._screenHeight / 4 - 36,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(Strings.welcomeOn, style: TextStyles.textLBold()),
              ),
            ),
            AnimatedLogo(animation: _logoAnimation),
            FadeTransition(opacity: _fadeAnimation, child: CircularProgressIndicator(color: AppColors.nightBlue)),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.warning, AppColors.primaryLighten],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key? key, required Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Positioned(
      top: animation.value,
      child: SvgPicture.asset(Drawables.icLogo, semanticsLabel: Strings.logoTextDescription),
    );
  }
}
