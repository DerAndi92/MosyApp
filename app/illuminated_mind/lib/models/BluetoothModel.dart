import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert' show utf8;

abstract class AbstractBluetoothModel extends Model {
  BluetoothDevice get device;
  List<BluetoothService> get services;
  void setDevice(BluetoothDevice device);
  void setServices(List<BluetoothService> services);
  void setSendingChar(BluetoothCharacteristic c);
  void writeCharacteristic(String text);
}

class BluetoothModel extends AbstractBluetoothModel {
  /// Device
  BluetoothDevice _device;
  List<BluetoothService> _services = new List();
  BluetoothCharacteristic _sendingChar;

  void setSendingChar(BluetoothCharacteristic c) {
    _sendingChar = c;
  }

  BluetoothCharacteristic get sendingChar {
    return _sendingChar;
  }

  void setDevice(BluetoothDevice device) {
    _device = device;
  }

  BluetoothDevice get device {
    return _device;
  }

  void setServices(List<BluetoothService> services) {
    _services = services;
  }

  List<BluetoothService> get services {
    return _services;
  }

  void writeCharacteristic(String text) async {
    var encoded = utf8.encode(text);

    await _device.writeCharacteristic(_sendingChar, encoded,
        type: CharacteristicWriteType.withResponse);
  }
}
