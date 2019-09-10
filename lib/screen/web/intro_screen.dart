import 'package:flutter/material.dart';
import 'package:sp_client/screen/connection/connect_device_screen.dart';

class WebIntroScreen extends StatefulWidget {
  @override
  _WebIntroScreenState createState() => _WebIntroScreenState();
}

class _WebIntroScreenState extends State<WebIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Theme.of(context).accentColor,
          ),
        ),
        Expanded(
          flex: 1,
          child: ConnectDeviceScreen(),
        )
      ],
    );
  }
}
