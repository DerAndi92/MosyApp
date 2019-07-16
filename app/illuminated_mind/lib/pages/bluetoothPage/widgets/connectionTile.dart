import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';

class ConnectionTile extends StatelessWidget {
  final BluetoothDeviceState deviceState;

  ConnectionTile(this.deviceState);

  _goToStart(BuildContext context, QuestModel model) {
    model.generateFinalResult();

    ScopedModel.of<AbstractBluetoothModel>(context).sendData("s0");
    Navigator.pushReplacementNamed(context, "/start");
  }

  _buildTile(BuildContext context, QuestModel model) {
    bool isDeviceConnected = (deviceState == BluetoothDeviceState.connected);
    return isDeviceConnected
        ? _buildConnectedView(model, context)
        : _buildIsConnectingView();
  }

  List<Widget> _buildIsConnectingView() {
    return <Widget>[
      Padding(
        child: CircularProgressIndicator(),
        padding: EdgeInsets.all(30),
      ),
      Text("Die Verbindung wird aufgebaut ...")
    ];
  }

  List<Widget> _buildConnectedView(QuestModel model, BuildContext context) {
    return <Widget>[
      Padding(
          child: Text("Die Verbindung wurde erfolgreich aufgebaut!"),
          padding: EdgeInsets.all(30)),
      (!(model.finalResult.length == 0))
          ? RaisedButton(
              child: Text("Spiel starten"),
              onPressed: () => _goToStart(context, model))
          : Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Container(
            alignment: Alignment(0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.only(bottom: 150),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _buildTile(context, model)),
            ),
          ),
    );
  }
}
