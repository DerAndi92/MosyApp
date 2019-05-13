import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';

class RuneSection extends StatelessWidget {
  final VoidCallback onTap;
  final int color;
  const RuneSection({this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => model.isRuneUsed(color)
          ? Image(
              image: AssetImage("assets/rune_0.png"),
            )
          : GestureDetector(
              onTap: () {
                onTap();
              },
              child: Container(
                child: Image(
                  image: AssetImage("assets/rune_" + color.toString() + ".png"),
                ),
              ),
            ),
    );
  }
}
