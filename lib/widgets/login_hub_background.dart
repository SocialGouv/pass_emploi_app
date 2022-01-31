import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';

class EntreeBackground extends StatelessWidget {
  const EntreeBackground({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.primary,
        ),
        ClipPath(
          child: Container(
            color: AppColors.primaryDarken.withOpacity(0.25),
          ),
          clipper: DiagonalClipper(),
        ),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 64,
              ),
              SvgPicture.asset(
                Drawables.passEmploiLogo,
                color: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/un_jeune_une_solution_logo.png",
              ),
              Expanded(
                child: Image.asset(
                  "assets/jeune_home.png",
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        )
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
