import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class EntreeBiseauBackground extends StatelessWidget {
  const EntreeBiseauBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.primary),
        ClipPath(
          clipper: DiagonalClipper(),
          child: Container(color: AppColors.primaryDarken.withOpacity(0.25)),
        ),
      ],
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
