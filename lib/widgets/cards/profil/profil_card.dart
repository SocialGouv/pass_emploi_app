import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class ProfilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const ProfilCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Margins.spacing_base),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [Shadows.radius_base],
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
