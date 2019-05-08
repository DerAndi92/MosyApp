import 'package:flutter/material.dart';

class RuneSection extends StatelessWidget {
  final VoidCallback onTap;
  final int color;
  const RuneSection({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        child: const Image(
          image: AssetImage("assets/rune_wasser.png"),
        ),
      ),
    );
  }
}
