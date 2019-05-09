import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/repository/remote/grpc_service.dart';
import 'package:sp_client/repository/remote/protobuf/build/connection.pbgrpc.dart';
import 'package:sp_client/util/utils.dart';

class HostConnectionScreen extends StatefulWidget {
  @override
  _HostConnectionScreenState createState() => _HostConnectionScreenState();
}

class _HostConnectionScreenState extends State<HostConnectionScreen> {
  PreferenceBloc _preferenceBloc;
  GrpcService _grpcService;

  Timer _timer;
  String _connectionCode;
  int _timeLeft = 0;

  @override
  void initState() {
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    _grpcService = GrpcService(
      host: _preferenceBloc.getPreference(AppPreferences.keyServiceHost).value,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _requestConnection();
      _startTimer();
    });
    SchedulerBinding.instance.ensureVisualUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !Util.isTablet(context)
          ? AppBar(
              title: Text(AppLocalizations.of(context).titleHostConnection),
              elevation: 0.0,
            )
          : null,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context).labelConnectionCode,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColorDark,
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _connectionCode ?? '000000',
                    style: TextStyle(
                      fontSize: 40.0,
                      letterSpacing: 8.0,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        _requestConnection();
                        _startTimer();
                      },
                    ),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(
              value: _timeLeft.toDouble() / 60,
              backgroundColor: Theme.of(context).primaryColorDark,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _requestConnection() async {
    var userIdPref = _preferenceBloc.getPreference(AppPreferences.keyUserId);
    var userId = userIdPref.value;
    if (userId == null) {
      var userIdResponse =
          await _grpcService.connectionServiceClient.requestUserId(Empty());
      userId = userIdResponse.userId;
      _preferenceBloc.dispatch(UpdatePreference(userIdPref..value = userId));
    }
    var connectionResponse =
        await _grpcService.connectionServiceClient.connection(
      ConnectionRequest()..userId = userId,
    );

    setState(() {
      _connectionCode = connectionResponse.connectionCode;
    });
  }

  void _startTimer() {
    setState(() {
      _timeLeft = 59;
    });

    if (_timer != null) _timer.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateProgress();
    });
  }

  void _updateProgress() {
    setState(() {
      if (_timeLeft == 0) {
        _requestConnection();
        _startTimer();
      } else {
        _timeLeft--;
      }
    });
  }
}
