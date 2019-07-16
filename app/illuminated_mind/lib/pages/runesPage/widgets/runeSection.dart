import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:flutter/animation.dart';

class RuneSection extends StatefulWidget {
  final bool Function() onTap;
  final int color;
  final List<double> position;

  const RuneSection({this.color, this.position, this.onTap});

  @override
  State<StatefulWidget> createState() {
    return _RuneSectionSate();
  }
}

class _RuneSectionSate extends State<RuneSection>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  double height;
  double width;

  @override
  void initState() {
    super.initState();
    height = 150;
    width = 150;
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        // #enddocregion addListener
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
        // #docregion addListener
      });
    // #enddocregion addListener
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Positioned(
            top: this.widget.position[0] +
                ((MediaQuery.of(context).size.height / 2 -
                        this.widget.position[0] -
                        ((height * (1 + animation.value)) / 2)) *
                    animation.value),
            left: this.widget.position[1] +
                ((MediaQuery.of(context).size.width / 2 -
                        this.widget.position[1] -
                        ((width * (1 + animation.value)) / 2)) *
                    animation.value),
            child: Container(
                height: height * (1 + animation.value),
                width: width * (1 + animation.value),
                child: model.isRuneUsed(this.widget.color)
                    ? Container()
                    : Opacity(
                        opacity: 1 - animation.value,
                        child: GestureDetector(
                          onTap: () {
                            if (this.widget.onTap()) controller.forward();
                          },
                          child: Image(
                            image: AssetImage("assets/pages/runes/rune_" +
                                this.widget.color.toString() +
                                ".png"),
                          ),
                        ),
                      )),
          ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
