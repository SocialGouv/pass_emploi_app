import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';

const _illustrationDefaultSize = 100.0;
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
      child: ColoredBox(color: AppColors.warningLighten),
    );
  }
}

class _Rond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
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
