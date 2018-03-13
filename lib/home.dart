import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_reader/QRCodeReader.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  String _qrCode;
  QRCodeReader reader;
  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      this._notification = state;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    this.reader = new QRCodeReader().setAutoFocusIntervalInMs(200);
    this._qrCode = "";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    this.reader = null;
    this._qrCode = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_notification == null || (_notification.index == 0 && _qrCode.length == 0)) {
      this.reader.scan().then((value) {
        setState(() => this._qrCode = value);
      });
    }
    return new Scaffold(
        appBar: new AppBar(title: const Text('Example code')),
        body: new Column(children: <Widget>[
          new Text(_qrCode),
          new Text('Last notification: $_notification')
        ])
    );
  }
}
