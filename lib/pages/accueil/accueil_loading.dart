import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:shimmer/shimmer.dart';

class AccueilLoading extends StatelessWidget {
  const AccueilLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_base),
        itemCount: placeholders.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          child: FadeInAnimation(
            child: SlideAnimation(
              child: placeholders[index],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        _placeholderBuilder(
          width: screenWidth * 0.5,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        _placeholderBuilder(
          width: screenWidth,
          height: 350,
        ),
        SizedBox(height: Margins.spacing_m),
        _placeholderBuilder(
          width: screenWidth * 0.8,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        _placeholderBuilder(
          width: screenWidth,
          height: 200,
        ),
      ];

  Widget _placeholderBuilder({
    required double width,
    required double height,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Shimmer.fromColors(
        baseColor: Color(0xFFE7E7E7),
        highlightColor: AppColors.grey100,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Color(0xFFE6E6E6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 16,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
