import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedListLoader extends StatelessWidget {
  const AnimatedListLoader({super.key, required this.placeholders, this.nested = false});
  final List<Widget> placeholders;
  final bool nested;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Shimmer.fromColors(
        baseColor: AppColors.loadingGreyPlaceholder,
        highlightColor: Colors.white,
        child: ListView.builder(
          shrinkWrap: nested,
          physics: nested ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_base),
          itemCount: placeholders.length,
          itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
            duration: AnimationDurations.fast,
            position: index,
            child: FadeInAnimation(
              child: SlideAnimation(
                child: placeholders[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget placeholderBuilder({
    required double width,
    required double height,
    AlignmentGeometry alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.loadingGreyPlaceholder,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius_base),
          ),
        ),
      ),
    );
  }
}
