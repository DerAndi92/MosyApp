import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AlertTile extends StatelessWidget {
  final BluetoothState state;
  AlertTile(this.state);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.red,
      child: new ListTile(
        title: new Text(
          'Bluetooth adapter is ${state.toString().substring(15)}',
          style: Theme.of(context).primaryTextTheme.subhead,
        ),
        trailing: new Icon(
          Icons.error,
          color: Theme.of(context).primaryTextTheme.subhead.color,
        ),
      ),
    );
  }
}
