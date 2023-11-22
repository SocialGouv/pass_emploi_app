import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class CredentialsPage extends StatefulWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CredentialsPage());
  }

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0, end: 360).chain(CurveTween(curve: Curves.elasticInOut)).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(child: Container(height: double.infinity, color: Color(0xFF3F6AD3))),
              Expanded(child: Container(height: double.infinity, color: Colors.white)),
              Expanded(child: Container(height: double.infinity, color: Color(0xFFF73620))),
            ],
          ),
          Center(child: AnimatedCredentials(listenable: _animation)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_m),
              child: PrimaryActionButton(onPressed: () => Navigator.pop(context), label: "Bien vu"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedCredentials extends AnimatedWidget {
  AnimatedCredentials({required super.listenable});

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value / 60,
      child: Image(image: AssetImage('assets/credentials.png'), width: max(100, animation.value)),
    );
  }
}
