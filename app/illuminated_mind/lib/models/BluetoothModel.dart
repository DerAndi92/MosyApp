import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

abstract class AbstractBluetoothModel extends Model {
  BluetoothDevice get device;
  void setDevice(BluetoothDevice device);

  List<BluetoothService> get services;
  void setServices(List<BluetoothService> services);

  void setCharacteristic(BluetoothCharacteristic c);
  void writeCharacteristic(String text);
}

class BluetoothModel extends AbstractBluetoothModel {
  BluetoothDevice _device;
  List<BluetoothService> _services = new List();
  BluetoothCharacteristic _characteristic;

  static BluetoothModel of(BuildContext context) =>
      ScopedModel.of<BluetoothModel>(context);

  // device
  BluetoothDevice get device {
    return _device;
  }

  void setDevice(BluetoothDevice device) {
    _device = device;
  }

  // service
  List<BluetoothService> get services {
    return _services;
  }

  void setServices(List<BluetoothService> services) {
    _services = services;
  }

  // characteristic
  BluetoothCharacteristic get characteristic {
    return _characteristic;
  }

  void setCharacteristic(BluetoothCharacteristic c) {
    _characteristic = c;
  }

  void writeCharacteristic(String text) async {
    var encoded = utf8.encode(text);
    print("SENDING => " + text);

    _characteristic != null &&
        await _device.writeCharacteristic(_characteristic, encoded,
            type: CharacteristicWriteType.withoutResponse);
  }
}
