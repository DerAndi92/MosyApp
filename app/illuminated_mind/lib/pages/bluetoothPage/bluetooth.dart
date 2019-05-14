// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/pages/bluetoothPage/bluetoothWidgets.dart';

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothState createState() => new _BluetoothState();
}

class _BluetoothState extends State<BluetoothPage> {
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice _device;
  bool get isConnected => (_device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue
    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  // @override
  // void dispose() {
  //   _stateSubscription?.cancel();
  //   _stateSubscription = null;
  //   _scanSubscription?.cancel();
  //   _scanSubscription = null;
  //   deviceConnection?.cancel();
  //   deviceConnection = null;
  //   super.dispose();
  // }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(timeout: const Duration(seconds: 5))
        .listen((scanResult) {
      setState(() {
        scanResults[scanResult.device.id] = scanResult;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _connect(BluetoothDevice d, AbstractBluetoothModel model) async {
    _device = d;
    model.setDevice(d);
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(_device, timeout: const Duration(seconds: 4))
        .listen(
          null,
          onDone: _disconnect,
        );
    // Update the connection state immediately
    _device.state.then((s) {
      setState(() {
        deviceState = s;
      });
    });

    // Subscribe to connection changes
    deviceStateSubscription = _device.onStateChanged().listen((s) {
      setState(() {
        deviceState = s;
      });
      if (s == BluetoothDeviceState.connected) {
        _device.discoverServices().then((s) {
          _setModel(s, model);
        });
      }
    });
  }

  _setModel(List<BluetoothService> s, AbstractBluetoothModel model) {
    BluetoothService sendingService = s.singleWhere((service) =>
        service.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb");
    model.setServices(s);

    BluetoothCharacteristic sendingChar = sendingService.characteristics
        .singleWhere(
            (c) => c.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb");
    model.setCharacteristic(sendingChar);
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      _device = null;
    });
  }

  _getFloatingButton() {
    if (isConnected || state != BluetoothState.on) {
      return null;
    }
    if (isScanning) {
      return FloatingActionButton(
        child: Icon(Icons.stop),
        onPressed: _stopScan,
      );
    } else {
      return FloatingActionButton(
          child: Icon(Icons.search), onPressed: _startScan);
    }
  }

  _getScanResultList(List<Widget> tiles, AbstractBluetoothModel model) {
    if (!isConnected) tiles.addAll(_addScanResultTiles(model));
    return tiles;
  }

  _addScanResultTiles(AbstractBluetoothModel model) {
    return scanResults.values
        .map((r) => ScanResultTile(
              result: r,
              onTap: () => _connect(r.device, model),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(AlertTile(state));
    }
    return ScopedModelDescendant<AbstractBluetoothModel>(
      builder: (context, child, model) => Scaffold(
            floatingActionButton: _getFloatingButton(),
            body: Stack(
              children: <Widget>[
                (isScanning) ? LinearProgressIndicator() : Container(),
                (isConnected)
                    ? ConnectionTile(deviceState)
                    : ListView(
                        children: _getScanResultList(tiles, model),
                      ),
              ],
            ),
          ),
    );
  }
}
