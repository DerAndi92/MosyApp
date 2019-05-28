import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';

class RuneSection extends StatelessWidget {
  final VoidCallback onTap;
  final int color;
  final List<double> position;

  const RuneSection({this.color, this.position, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Positioned(
            top: position[0],
            left: position[1],
            child: Container(
              height: 150.0,
              width: 150.0,
              child: model.isRuneUsed(color)
                  ? Image(
                      width: 150,
                      height: 150,
                      image: AssetImage("assets/pages/runes/rune_0.png"),
                    )
                  : GestureDetector(
                      onTap: () {
                        onTap();
                      },
                      child: Image(
                        width: 150,
                        height: 150,
                        image: AssetImage("assets/pages/runes/rune_" +
                            color.toString() +
                            ".png"),
                      ),
                    ),
            ),
          ),
    );
  }
}
