import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class ProfilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const ProfilCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(Margins.spacing_base),
  }) : super(key: key);

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
          boxShadow: [Shadows.boxShadow],
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
