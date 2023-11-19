import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final double? top;
  final double? left;
  const Bubble({
    super.key,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlueAccent.withOpacity(0.2)),
        child: const Icon(
          Icons.circle_outlined,
          size: 100,
        ),
      ),
    );
  }
}
