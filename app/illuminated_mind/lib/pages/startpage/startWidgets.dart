import 'package:flutter/material.dart';

class SpeechBubbleWidget extends StatelessWidget {
  final String text;

  SpeechBubbleWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bubble.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          child: Text(text, style: TextStyle(color: Colors.black)),
          padding:
              EdgeInsets.only(left: 40.0, top: 40.0, right: 40.0, bottom: 80.0),
        ));
  }
}
