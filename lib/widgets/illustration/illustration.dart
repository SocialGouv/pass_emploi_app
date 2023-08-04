import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';

const _illustrationDefaultSize = 300.0;
const _illustrationFigmaSize = 300.0;

class Illustration extends StatelessWidget {
  const Illustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _Assemblage(scale: _illustrationDefaultSize / _illustrationFigmaSize);
  }
}

class _Assemblage extends StatelessWidget {
  final double scale;

  _Assemblage({required this.scale});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Transform.scale(
        scale: scale,
        child: SizedBox.square(
          // dimension: _illustrationFigmaSize,
          child: Stack(
            alignment: Alignment.center,
            // fit: StackFit.expand,
            children: [
              _Fond(),
              _Rond(),
              _Icone(),
            ],
          ),
        ),
      );
    });
  }
}

class _Fond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _illustrationFigmaSize,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 10,
            child: circle(),
          ),
          Positioned(
            bottom: 0,
            right: 10,
            child: circle(),
          ),
          Positioned(
            top: 41,
            right: 0,
            child: square(83),
          ),
          Positioned(
            bottom: 28,
            left: 0,
            child: square(77),
          ),
        ],
      ),
    );
  }

  Widget circle() => Container(
        width: 132,
        height: 132,
        decoration: BoxDecoration(
          color: AppColors.warningLighten,
          shape: BoxShape.circle,
        ),
      );

  Widget square(double angle) {
    final rad = angle * pi / 180;
    return Transform.rotate(
      angle: -rad,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.warningLighten,
        ),
      ),
    );
  }
}

class _Rond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 206,
      height: 206,
      decoration: BoxDecoration(
        color: AppColors.warning,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Icone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      AppIcons.delete,
      color: Colors.white,
      size: 80,
    );
  }
}
