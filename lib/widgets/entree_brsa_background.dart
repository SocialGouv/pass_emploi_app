import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class EntreeBrsaBackground extends StatelessWidget {
  const EntreeBrsaBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.primary),
        ClipPath(
          clipper: HalfCircleClipper(),
          child: Container(color: AppColors.primaryLighten),
        ),
      ],
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double radius = size.width / 2;
    final double centerY = size.height * 0.1;

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, centerY);
    path.arcToPoint(
      Offset(0, centerY),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
