import 'package:flutter/material.dart';
import 'package:flutter_app_testing/home.dart';


class App extends StatefulWidget {
  const App({
    Key key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new AppState();
}

class AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Home());
  }

}