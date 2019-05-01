import 'package:flutter/material.dart';

class RunesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 2,
      children: <Widget>[
        const Image(
          image: AssetImage("assets/rune_wasser.png"),
        ),
        const Image(
          image: AssetImage("assets/rune_feuer.png"),
        ),
        const Image(
          image: AssetImage("assets/rune_wasser.png"),
        ),
        const Image(
          image: AssetImage("assets/rune_feuer.png"),
        ),
        const Image(
          image: AssetImage("assets/rune_wasser.png"),
        ),
        const Image(
          image: AssetImage("assets/rune_feuer.png"),
        ),
      ],
    ));
  }
}
