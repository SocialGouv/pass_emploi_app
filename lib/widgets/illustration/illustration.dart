import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

const _illustrationFigmaSize = 300.0;

class Illustration extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const Illustration({
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });

  factory Illustration.red(
    IconData icon,
  ) {
    return Illustration(
      primaryColor: AppColors.warning,
      secondaryColor: AppColors.warningLighten,
      icon: icon,
    );
  }

  factory Illustration.blue(IconData icon) {
    return Illustration(
      primaryColor: AppColors.primary,
      secondaryColor: AppColors.primaryLighten,
      icon: icon,
    );
  }

  factory Illustration.green(IconData icon) {
    return Illustration(
      primaryColor: AppColors.successDarken,
      secondaryColor: AppColors.successLighten,
      icon: icon,
    );
  }

  factory Illustration.orange(IconData icon) {
    return Illustration(
      primaryColor: AppColors.alert,
      secondaryColor: AppColors.alertLighten,
      icon: icon,
    );
  }

  factory Illustration.grey(IconData icon, {bool withWhiteBackground = false}) {
    return Illustration(
      primaryColor: AppColors.disabled,
      secondaryColor: withWhiteBackground ? Colors.white : AppColors.grey100,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Assemblage(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      icon: icon,
    );
  }
}

class _Assemblage extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;

  const _Assemblage({
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox.square(
        dimension: constraints.maxWidth,
        child: OverflowBox(
          maxWidth: _illustrationFigmaSize,
          maxHeight: _illustrationFigmaSize,
          child: Transform.scale(
            scale: constraints.maxWidth / _illustrationFigmaSize,
            child: SizedBox.square(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _Fond(color: secondaryColor),
                  _Rond(color: primaryColor),
                  _Icone(icon: icon),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _Fond extends StatelessWidget {
  final Color color;

  const _Fond({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _illustrationFigmaSize,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 10,
            child: circle(color: color),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: circle(color: color),
          ),
          Positioned(
            top: 41,
            right: 0,
            child: square(color: color, rotation: 83),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            child: square(color: color, rotation: 77),
          ),
        ],
      ),
    );
  }

  Widget circle({required Color color}) {
    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget square({required Color color, required double rotation}) {
    final radian = rotation * pi / 180;
    return Transform.rotate(
      angle: -radian,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }
}

class _Rond extends StatelessWidget {
  final Color color;

  const _Rond({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 206,
      height: 206,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Icone extends StatelessWidget {
  final IconData icon;

  const _Icone({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: 80,
    );
  }
}
