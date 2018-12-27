import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sp_client/localizations.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  factory SplashScreen.forDesignTime() {
    return new SplashScreen();
  }

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(),
          Container(
              width: 128,
              height: 128,
              decoration:
                  BoxDecoration(color: Colors.black12, shape: BoxShape.circle)),
          Padding(
            padding: const EdgeInsets.only(bottom: 72.0),
            child: Text(AppLocalizations.of(context).get('title'),
                style: Theme.of(context).textTheme.title),
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, _navigationMain);
  }

  _navigationMain() {
    Navigator.of(context).pushReplacementNamed('/main');
  }
}
