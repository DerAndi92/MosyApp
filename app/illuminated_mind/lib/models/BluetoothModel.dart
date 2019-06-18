import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

abstract class AbstractBluetoothModel extends Model {
  BluetoothDevice get device;
  void setDevice(BluetoothDevice device);
  void sendData(String text);

  List<BluetoothService> get services;
  void setServices(List<BluetoothService> services);

  void setCharacteristic(BluetoothCharacteristic c);
  void writeCharacteristic(String text);
}

class BluetoothModel extends AbstractBluetoothModel {
  BluetoothDevice _device;
  List<BluetoothService> _services = new List();
  BluetoothCharacteristic _characteristic;

  List<String> listToSend = [];

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

  void setCharacteristic(BluetoothCharacteristic c) async {
    _characteristic = c;
    await device.setNotifyValue(c, true);
    device.onValueChanged(c).listen((d) {
      var decodedText = utf8.decode(d).trim();
      listToSend.remove(decodedText);
      if (listToSend.isNotEmpty) {
        sendData(listToSend[0], isNext: true);
      }
    });
  }

  void sendData(String text, {bool isNext = false}) async {
    if (listToSend.isEmpty) {
      listToSend.add(text.trim());
      writeCharacteristic(text);
    } else if (isNext) {
      writeCharacteristic(text);
    } else {
      listToSend.add(text.trim());
    }
  }

  void writeCharacteristic(String text) async {
    var encoded = utf8.encode(text);
    print("SENDING => " + text);
    _characteristic != null &&
        await _device.writeCharacteristic(_characteristic, encoded,
            type: CharacteristicWriteType.withoutResponse);
  }
}
