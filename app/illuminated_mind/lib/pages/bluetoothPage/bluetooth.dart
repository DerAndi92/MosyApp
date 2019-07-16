import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:illuminated_mind/pages/bluetoothPage/widgets/alertTile.dart';
import 'package:illuminated_mind/pages/bluetoothPage/widgets/connectionTile.dart';
import 'package:illuminated_mind/pages/bluetoothPage/widgets/scanResultTile.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';

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
  bool scanned = false;

  //Images
  Image _imgBluetoothBtn;
  Image _imgBluetoothStopBtn;
  Image _imgBluetoothBox;

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

    // prepare images
    _imgBluetoothBtn = Image.asset("assets/pages/bluetooth/bluetooth_btn.png");
    _imgBluetoothStopBtn =
        Image.asset("assets/pages/bluetooth/bluetooth_stop_btn.png");
    _imgBluetoothBox = Image.asset("assets/pages/bluetooth/bluetooth_box.png");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_imgBluetoothBtn.image, context);
    precacheImage(_imgBluetoothStopBtn.image, context);
    precacheImage(_imgBluetoothBox.image, context);
  }

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
      scanned = true;
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
    // Set global device at Scopedmodel
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

  _onSearchButtonPress() {
    ScopedModel.of<AudioModel>(context).play("click.mp3");
    (isScanning) ? _stopScan() : _startScan();
  }

  _getSearchButton() {
    return Container(
        margin: const EdgeInsets.only(top: 550.0, left: 65.0, right: 65.0),
        child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: FlatButton(
                onPressed: _onSearchButtonPress,
                padding: EdgeInsets.all(0.0),
                child:
                    (isScanning) ? _imgBluetoothStopBtn : _imgBluetoothBtn)));
  }

  _buildScanListView(tiles, AbstractBluetoothModel model) {
    if (scanned) {
      return Container(
        margin: const EdgeInsets.only(
            top: 275.0, bottom: 100.0, left: 16.0, right: 16.0),
        padding: const EdgeInsets.only(top: 3.5, bottom: 7.0),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: _imgBluetoothBox.image,
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          children: _getScanResultList(tiles, model),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var tiles = List<Widget>();
    if (state != BluetoothState.on) {
      tiles.add(AlertTile(state));
    }
    ScopedModel.of<AudioModel>(context).loadAudio();

    return ScopedModelDescendant<AbstractBluetoothModel>(
      builder: (context, child, model) => Scaffold(
            body: Stack(
              children: <Widget>[
                new Container(
                    decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image:
                        new AssetImage("assets/pages/bluetooth/background.png"),
                    fit: BoxFit.cover,
                  ),
                )),
                // display progressbar or empty Container
                (isScanning) ? LinearProgressIndicator() : Container(),

                // display current ConnectionView or scanned ListView
                (isConnected)
                    ? ConnectionTile(deviceState)
                    : _buildScanListView(tiles, model),

                // display search-Icon or empy Container
                (!isConnected || state != BluetoothState.on)
                    ? _getSearchButton()
                    : Container(),
              ],
            ),
          ),
    );
  }
}
