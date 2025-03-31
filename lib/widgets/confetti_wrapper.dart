import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiWrapper extends StatefulWidget {
  const ConfettiWrapper({super.key, required this.builder});
  final Widget Function(BuildContext context, ConfettiController confettiController) builder;

  @override
  State<ConfettiWrapper> createState() => _ConfettiWrapperState();
}

class _ConfettiWrapperState extends State<ConfettiWrapper> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context, _confettiController),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            createParticlePath: isWinter
                ? (size) => _snowPath(size)
                : isSpring
                    ? (size) => _flowerPath(size)
                    : null,
            colors: isWinter
                ? [
                    Color(0xFF88EDFF),
                    Color(0xFF1779DD),
                    Color(0xFF5D9EEA),
                    Color(0xFF92B0F2),
                  ]
                : isSpring
                    ? [
                        Color(0xFFFF8C8C),
                        Color(0xFFD1DD93),
                        Color(0xFFF1EDA9),
                        Color(0xFFC3D5F4),
                        Color(0xFFBDEEED),
                      ]
                    : null,
            gravity: 0.2,
            numberOfParticles: 50,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }

  Path _snowPath(Size size) {
    final Path path_0 = Path();
    path_0.moveTo(12, 4);
    path_0.cubicTo(12.2761, 4, 12.5, 4.22386, 12.5, 4.5);
    path_0.lineTo(12.5, 6.29289);
    path_0.lineTo(13.6464, 5.14645);
    path_0.cubicTo(13.8417, 4.95118, 14.1583, 4.95118, 14.3536, 5.14645);
    path_0.cubicTo(14.5488, 5.34171, 14.5488, 5.65829, 14.3536, 5.85355);
    path_0.lineTo(12.5, 7.70711);
    path_0.lineTo(12.5, 10.7929);
    path_0.lineTo(14.7891, 8.5038);
    path_0.lineTo(14.7891, 6);
    path_0.cubicTo(14.7891, 5.72386, 15.013, 5.5, 15.2891, 5.5);
    path_0.cubicTo(15.5652, 5.5, 15.7891, 5.72386, 15.7891, 6);
    path_0.lineTo(15.7891, 7.5038);
    path_0.lineTo(17.1464, 6.14645);
    path_0.cubicTo(17.3417, 5.95118, 17.6583, 5.95118, 17.8536, 6.14645);
    path_0.cubicTo(18.0488, 6.34171, 18.0488, 6.65829, 17.8536, 6.85355);
    path_0.lineTo(16.4962, 8.2109);
    path_0.lineTo(18, 8.2109);
    path_0.cubicTo(18.2761, 8.2109, 18.5, 8.43476, 18.5, 8.7109);
    path_0.cubicTo(18.5, 8.98705, 18.2761, 9.2109, 18, 9.2109);
    path_0.lineTo(15.4962, 9.2109);
    path_0.lineTo(13.2071, 11.5);
    path_0.lineTo(16.2929, 11.5);
    path_0.lineTo(18.1464, 9.64645);
    path_0.cubicTo(18.3417, 9.45118, 18.6583, 9.45118, 18.8536, 9.64645);
    path_0.cubicTo(19.0488, 9.84171, 19.0488, 10.1583, 18.8536, 10.3536);
    path_0.lineTo(17.7071, 11.5);
    path_0.lineTo(19.5, 11.5);
    path_0.cubicTo(19.7761, 11.5, 20, 11.7239, 20, 12);
    path_0.cubicTo(20, 12.2761, 19.7761, 12.5, 19.5, 12.5);
    path_0.lineTo(17.7071, 12.5);
    path_0.lineTo(18.8536, 13.6464);
    path_0.cubicTo(19.0488, 13.8417, 19.0488, 14.1583, 18.8536, 14.3536);
    path_0.cubicTo(18.6583, 14.5488, 18.3417, 14.5488, 18.1464, 14.3536);
    path_0.lineTo(16.2929, 12.5);
    path_0.lineTo(13.2071, 12.5);
    path_0.lineTo(15.4962, 14.7891);
    path_0.lineTo(18, 14.7891);
    path_0.cubicTo(18.2761, 14.7891, 18.5, 15.013, 18.5, 15.2891);
    path_0.cubicTo(18.5, 15.5652, 18.2761, 15.7891, 18, 15.7891);
    path_0.lineTo(16.4962, 15.7891);
    path_0.lineTo(17.8536, 17.1464);
    path_0.cubicTo(18.0488, 17.3417, 18.0488, 17.6583, 17.8536, 17.8536);
    path_0.cubicTo(17.6583, 18.0488, 17.3417, 18.0488, 17.1464, 17.8536);
    path_0.lineTo(15.7891, 16.4962);
    path_0.lineTo(15.7891, 18);
    path_0.cubicTo(15.7891, 18.2761, 15.5652, 18.5, 15.2891, 18.5);
    path_0.cubicTo(15.013, 18.5, 14.7891, 18.2761, 14.7891, 18);
    path_0.lineTo(14.7891, 15.4962);
    path_0.lineTo(12.5, 13.2071);
    path_0.lineTo(12.5, 16.2929);
    path_0.lineTo(14.3536, 18.1464);
    path_0.cubicTo(14.5488, 18.3417, 14.5488, 18.6583, 14.3536, 18.8536);
    path_0.cubicTo(14.1583, 19.0488, 13.8417, 19.0488, 13.6464, 18.8536);
    path_0.lineTo(12.5, 17.7071);
    path_0.lineTo(12.5, 19.5);
    path_0.cubicTo(12.5, 19.7761, 12.2761, 20, 12, 20);
    path_0.cubicTo(11.7239, 20, 11.5, 19.7761, 11.5, 19.5);
    path_0.lineTo(11.5, 17.7071);
    path_0.lineTo(10.3536, 18.8536);
    path_0.cubicTo(10.1583, 19.0488, 9.84171, 19.0488, 9.64645, 18.8536);
    path_0.cubicTo(9.45118, 18.6583, 9.45118, 18.3417, 9.64645, 18.1464);
    path_0.lineTo(11.5, 16.2929);
    path_0.lineTo(11.5, 13.2071);
    path_0.lineTo(9.2109, 15.4962);
    path_0.lineTo(9.2109, 18);
    path_0.cubicTo(9.2109, 18.2761, 8.98705, 18.5, 8.7109, 18.5);
    path_0.cubicTo(8.43476, 18.5, 8.2109, 18.2761, 8.2109, 18);
    path_0.lineTo(8.2109, 16.4962);
    path_0.lineTo(6.85355, 17.8536);
    path_0.cubicTo(6.65829, 18.0488, 6.34171, 18.0488, 6.14645, 17.8536);
    path_0.cubicTo(5.95118, 17.6583, 5.95118, 17.3417, 6.14645, 17.1464);
    path_0.lineTo(7.5038, 15.7891);
    path_0.lineTo(6, 15.7891);
    path_0.cubicTo(5.72386, 15.7891, 5.5, 15.5652, 5.5, 15.2891);
    path_0.cubicTo(5.5, 15.013, 5.72386, 14.7891, 6, 14.7891);
    path_0.lineTo(8.5038, 14.7891);
    path_0.lineTo(10.7929, 12.5);
    path_0.lineTo(7.70711, 12.5);
    path_0.lineTo(5.85355, 14.3536);
    path_0.cubicTo(5.65829, 14.5488, 5.34171, 14.5488, 5.14645, 14.3536);
    path_0.cubicTo(4.95118, 14.1583, 4.95118, 13.8417, 5.14645, 13.6464);
    path_0.lineTo(6.29289, 12.5);
    path_0.lineTo(4.5, 12.5);
    path_0.cubicTo(4.22386, 12.5, 4, 12.2761, 4, 12);
    path_0.cubicTo(4, 11.7239, 4.22386, 11.5, 4.5, 11.5);
    path_0.lineTo(6.29289, 11.5);
    path_0.lineTo(5.14645, 10.3536);
    path_0.cubicTo(4.95118, 10.1583, 4.95118, 9.84171, 5.14645, 9.64645);
    path_0.cubicTo(5.34171, 9.45118, 5.65829, 9.45118, 5.85355, 9.64645);
    path_0.lineTo(7.70711, 11.5);
    path_0.lineTo(10.7929, 11.5);
    path_0.lineTo(8.5038, 9.2109);
    path_0.lineTo(6, 9.2109);
    path_0.cubicTo(5.72386, 9.2109, 5.5, 8.98705, 5.5, 8.7109);
    path_0.cubicTo(5.5, 8.43476, 5.72386, 8.2109, 6, 8.2109);
    path_0.lineTo(7.5038, 8.2109);
    path_0.lineTo(6.14645, 6.85355);
    path_0.cubicTo(5.95118, 6.65829, 5.95118, 6.34171, 6.14645, 6.14645);
    path_0.cubicTo(6.34171, 5.95118, 6.65829, 5.95118, 6.85355, 6.14645);
    path_0.lineTo(8.2109, 7.5038);
    path_0.lineTo(8.2109, 6);
    path_0.cubicTo(8.2109, 5.72386, 8.43476, 5.5, 8.7109, 5.5);
    path_0.cubicTo(8.98705, 5.5, 9.2109, 5.72386, 9.2109, 6);
    path_0.lineTo(9.2109, 8.5038);
    path_0.lineTo(11.5, 10.7929);
    path_0.lineTo(11.5, 7.70711);
    path_0.lineTo(9.64645, 5.85355);
    path_0.cubicTo(9.45118, 5.65829, 9.45118, 5.34171, 9.64645, 5.14645);
    path_0.cubicTo(9.84171, 4.95118, 10.1583, 4.95118, 10.3536, 5.14645);
    path_0.lineTo(11.5, 6.29289);
    path_0.lineTo(11.5, 4.5);
    path_0.cubicTo(11.5, 4.22386, 11.7239, 4, 12, 4);
    path_0.close();
    return path_0;
  }

  bool get isWinter => DateTime.now().month == DateTime.december || DateTime.now().month == DateTime.january;

  Path _flowerPath(Size size) {
    final Path path_0 = Path();
    path_0.moveTo(size.width * 0.3428, size.height * 0.0644);
    path_0.cubicTo(size.width * 0.3732, size.height * 0.0341, size.width * 0.4160, size.height * 0.0133,
        size.width * 0.4652, size.height * 0.0091);
    path_0.cubicTo(size.width * 0.5144, size.height * 0.0049, size.width * 0.5670, size.height * 0.0097,
        size.width * 0.6150, size.height * 0.0247);
    path_0.cubicTo(size.width * 0.6630, size.height * 0.0397, size.width * 0.7049, size.height * 0.0745,
        size.width * 0.7369, size.height * 0.1194);
    path_0.cubicTo(size.width * 0.7689, size.height * 0.1643, size.width * 0.7839, size.height * 0.2172,
        size.width * 0.7854, size.height * 0.2716);
    path_0.cubicTo(size.width * 0.8154, size.height * 0.2633, size.width * 0.8535, size.height * 0.2677,
        size.width * 0.8829, size.height * 0.2827);
    path_0.cubicTo(size.width * 0.9123, size.height * 0.2977, size.width * 0.9404, size.height * 0.3237,
        size.width * 0.9590, size.height * 0.3596);
    path_0.cubicTo(size.width * 0.9772, size.height * 0.3947, size.width * 0.9737, size.height * 0.4404,
        size.width * 0.9489, size.height * 0.4841);
    path_0.cubicTo(size.width * 0.9240, size.height * 0.5278, size.width * 0.8834, size.height * 0.5586,
        size.width * 0.8545, size.height * 0.5698);
    path_0.cubicTo(size.width * 0.8866, size.height * 0.6231, size.width * 0.8977, size.height * 0.6876,
        size.width * 0.8887, size.height * 0.7451);
    path_0.cubicTo(size.width * 0.8798, size.height * 0.8027, size.width * 0.8505, size.height * 0.8540,
        size.width * 0.8093, size.height * 0.8834);
    path_0.cubicTo(size.width * 0.7680, size.height * 0.9130, size.width * 0.7091, size.height * 0.9229,
        size.width * 0.6414, size.height * 0.9120);
    path_0.cubicTo(size.width * 0.5736, size.height * 0.9011, size.width * 0.5341, size.height * 0.8726,
        size.width * 0.4990, size.height * 0.8282);
    path_0.cubicTo(size.width * 0.4790, size.height * 0.8558, size.width * 0.4470, size.height * 0.8784,
        size.width * 0.4104, size.height * 0.8946);
    path_0.cubicTo(size.width * 0.3739, size.height * 0.9109, size.width * 0.3400, size.height * 0.9197,
        size.width * 0.3053, size.height * 0.9170);
    path_0.cubicTo(size.width * 0.2706, size.height * 0.9143, size.width * 0.2379, size.height * 0.9008,
        size.width * 0.2132, size.height * 0.8763);
    path_0.cubicTo(size.width * 0.1885, size.height * 0.8519, size.width * 0.1629, size.height * 0.8160,
        size.width * 0.1385, size.height * 0.7721);
    path_0.cubicTo(size.width * 0.1171, size.height * 0.7356, size.width * 0.1068, size.height * 0.6873,
        size.width * 0.1075, size.height * 0.6377);
    path_0.cubicTo(size.width * 0.1082, size.height * 0.5881, size.width * 0.1199, size.height * 0.5393,
        size.width * 0.1428, size.height * 0.5015);
    path_0.cubicTo(size.width * 0.0898, size.height * 0.4935, size.width * 0.0464, size.height * 0.4611,
        size.width * 0.0218, size.height * 0.4165);
    path_0.cubicTo(size.width * -0.0028, size.height * 0.3719, size.width * -0.0068, size.height * 0.3250,
        size.width * 0.0108, size.height * 0.2834);
    path_0.cubicTo(size.width * 0.0284, size.height * 0.2418, size.width * 0.0660, size.height * 0.2055,
        size.width * 0.1159, size.height * 0.1806);
    path_0.cubicTo(size.width * 0.1658, size.height * 0.1556, size.width * 0.2227, size.height * 0.1501,
        size.width * 0.2785, size.height * 0.1652);
    path_0.cubicTo(size.width * 0.2804, size.height * 0.1214, size.width * 0.3018, size.height * 0.0812,
        size.width * 0.3428, size.height * 0.0645);
    path_0.close();

    path_0.moveTo(size.width * 0.6559, size.height * 0.5036);
    path_0.cubicTo(size.width * 0.6559, size.height * 0.5900, size.width * 0.5854, size.height * 0.6600,
        size.width * 0.4984, size.height * 0.6600);
    path_0.cubicTo(size.width * 0.4554, size.height * 0.6603, size.width * 0.4139, size.height * 0.6425,
        size.width * 0.3830, size.height * 0.6112);
    path_0.cubicTo(size.width * 0.3521, size.height * 0.5799, size.width * 0.3325, size.height * 0.5372,
        size.width * 0.3323, size.height * 0.5036);
    path_0.cubicTo(size.width * 0.3323, size.height * 0.4171, size.width * 0.4028, size.height * 0.3471,
        size.width * 0.4898, size.height * 0.3471);
    path_0.cubicTo(size.width * 0.5768, size.height * 0.3471, size.width * 0.6559, size.height * 0.4171,
        size.width * 0.6559, size.height * 0.5036);
    path_0.close();

    return path_0;
  }

  bool get isSpring {
    final now = DateTime.now();
    return (now.month == DateTime.march && now.day >= 20) || (now.month == DateTime.april);
  }
}
