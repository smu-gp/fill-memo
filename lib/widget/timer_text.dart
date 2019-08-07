import 'dart:async';

import 'package:flutter/material.dart';

typedef TimerCallback = void Function(Duration);

class TimerText extends StatefulWidget {
  final Duration _duration;
  final Color color;
  final Color warnColor;
  final TimerCallback onChanged;

  const TimerText({
    Key key,
    @required Duration duration,
    @required this.color,
    this.onChanged,
    this.warnColor,
  })  : assert(duration != null),
        _duration = duration,
        super(key: key);

  @override
  TimerTextState createState() => TimerTextState();
}

class TimerTextState extends State<TimerText> {
  Timer _timer;
  int _timeLeft = 0;

  @override
  Widget build(BuildContext context) {
    var color = widget.color;
    if (_timeLeft <= 10 && widget.warnColor != null) {
      color = widget.warnColor;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.timer, color: color),
        SizedBox(width: 8.0),
        Text(
          "${_timeLeft ~/ 60}:${_timeLeft % 60}",
          style: TextStyle(color: color),
        ),
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
        if (widget.onChanged != null) {
          widget.onChanged(Duration(seconds: _timeLeft));
        }
      }
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
