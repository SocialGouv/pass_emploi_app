import 'package:flutter/material.dart';

class RefreshIndicatorAddingScrollview extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const RefreshIndicatorAddingScrollview({
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: child,
          ),
        ],
      ),
    );
  }
}
