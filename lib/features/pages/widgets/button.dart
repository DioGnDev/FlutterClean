import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.amber,
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
