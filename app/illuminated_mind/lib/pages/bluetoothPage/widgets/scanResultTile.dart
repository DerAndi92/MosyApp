import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';

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
