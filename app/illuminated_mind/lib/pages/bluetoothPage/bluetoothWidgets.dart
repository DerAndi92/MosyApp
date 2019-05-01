import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../startPage/start.dart';

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
  final VoidCallback onTap;

  ConnectionTile(this.deviceState, {this.onTap});

  _buildTile(BuildContext context) {
    bool isDeviceConnected = (deviceState == BluetoothDeviceState.connected);
    return isDeviceConnected
        ? <Widget>[
            Padding(
                child: Text("Die Verbindung wurde erfolgreich aufgebaut!"),
                padding: EdgeInsets.all(30)),
            RaisedButton(
                child: Text("Spiel starten"),
                onPressed: () => {
                      Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => StartPage()),
                      ),
                    }),
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
    return new Container(
      alignment: Alignment(0.0, 0.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildTile(context)),
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
