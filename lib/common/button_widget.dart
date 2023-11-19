import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final bool homeColor;
  final String title;
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.homeColor = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 8,
            backgroundColor: homeColor ? Colors.teal.shade400 : Colors.black26),
        onPressed: onPressed,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
    );
  }
}
