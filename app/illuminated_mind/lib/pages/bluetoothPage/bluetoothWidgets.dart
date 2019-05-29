import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:illuminated_mind/pages/startPage/start.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';

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

class ConnectionTile extends StatelessWidget {
  final BluetoothDeviceState deviceState;

  ConnectionTile(this.deviceState);

  _goToStart(BuildContext context) {
    ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic("s0");
    Navigator.pushReplacementNamed(context, "/start");
  }

  _buildTile(BuildContext context, QuestModel model) {
    bool isDeviceConnected = (deviceState == BluetoothDeviceState.connected);
    return isDeviceConnected
        ? <Widget>[
            Padding(
                child: Text("Die Verbindung wurde erfolgreich aufgebaut!"),
                padding: EdgeInsets.all(30)),
            Text("Der Lösungscode ist:"),
            Text(model.finalResult.toString()),
            Padding(
              child: RaisedButton(
                onPressed: () => model.generateFinalResult(),
                child: Text("Code generieren"),
              ),
              padding: EdgeInsets.all(30),
            ),
            (!(model.finalResult.length == 0))
                ? RaisedButton(
                    child: Text("Spiel starten"),
                    onPressed: () => _goToStart(context))
                : Container(),
          ]
        : <Widget>[
            Padding(
              child: CircularProgressIndicator(),
              padding: EdgeInsets.all(30),
            ),
            Text("Die Verbindung wird aufgebaut ...")
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
          )),
    );
  }
}

class ScanResultTile extends StatelessWidget {
  const ScanResultTile({this.result, this.onTap});

  final ScanResult result;
  final VoidCallback onTap;

  Widget _buildTitle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        (result.device.name.length > 0)
            ? Text(
                result.device.name,
                style: Theme.of(context).textTheme.body1,
              )
            : Text(
                result.device.id.toString(),
                style: Theme.of(context).textTheme.body1,
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: _buildTitle(context),
      trailing: RaisedButton(
        child: Text('Verbinden'),
        onPressed: (result.advertisementData.connectable) ? onTap : null,
      ),
    );
  }
}
