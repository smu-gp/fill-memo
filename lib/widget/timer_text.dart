import 'dart:async';

import 'package:flutter/material.dart';

class TimerText extends StatefulWidget {
  final Duration _duration;

  const TimerText({Key key, @required Duration duration})
      : assert(duration != null),
        _duration = duration,
        super(key: key);

  @override
  TimerTextState createState() => TimerTextState();
}

class TimerTextState extends State<TimerText> {
  Timer _timer;
  int _timeLeft = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.timer),
        SizedBox(width: 8.0),
        Text("${_timeLeft ~/ 60}:${_timeLeft % 60}"),
      ],
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _timeLeft = widget._duration.inSeconds;
    });

    if (_timer != null) _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft != 0) {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
