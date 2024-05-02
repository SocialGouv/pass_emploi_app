import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/animated_list_loader.dart';

class AccueilLoading extends StatelessWidget {
  const AccueilLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final placeholders = _placeholders(screenWidth);
    return AnimatedListLoader(
      nested: true,
      placeholders: placeholders,
    );
  }

  List<Widget> _placeholders(double screenWidth) => [
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth * 0.5,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 320,
        ),
        SizedBox(height: Margins.spacing_m),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth * 0.8,
          height: 35,
        ),
        SizedBox(height: Margins.spacing_base),
        AnimatedListLoader.placeholderBuilder(
          width: screenWidth,
          height: 200,
        ),
      ];
}
