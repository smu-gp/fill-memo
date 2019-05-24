import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:sp_client/bloc/preference/preference_bloc.dart';
import 'package:sp_client/service/grpc_service.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';
import 'package:sp_client/util/utils.dart';
import 'package:uuid/uuid.dart';

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

  StreamController<WaitAuthRequest> _waitAuthRequestController =
      StreamController();
  ResponseStream<WaitAuthResponse> _waitAuthResponseStream;

  @override
  void initState() {
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    _grpcService = GrpcService(
        host: _preferenceBloc.repository
            .getString(AppPreferences.keyServiceHost));
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      var userId = await _getUserId();
      _waitAuth(userId);
      _requestConnection(userId);
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
                      onPressed: _refreshConnectionCode,
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
    if (_waitAuthRequestController != null &&
        !_waitAuthRequestController.isClosed) {
      _waitAuthRequestController.close();
    }
    if (_waitAuthResponseStream != null) {
      _waitAuthResponseStream.cancel();
    }
    super.dispose();
  }

  Future<String> _getUserId() async {
    var userId = _preferenceBloc.repository.getString(AppPreferences.keyUserId);
    if (userId == null) {
      var uuid = Uuid();
      _preferenceBloc.repository.setString(AppPreferences.keyUserId, uuid.v4());
    }
    return userId;
  }

  void _refreshConnectionCode() async {
    var userId = await _getUserId();
    _requestConnection(userId);
    _startTimer();
  }

  void _waitAuth(String userId) async {
    _waitAuthResponseStream = _grpcService.connectionServiceClient.waitAuth(
      _waitAuthRequestController.stream,
      options: CallOptions(
        timeout: Duration(minutes: 30),
      ),
    );
    _waitAuthRequestController.add(WaitAuthRequest()..userId = userId);
    try {
      await for (var response in _waitAuthResponseStream) {
        _showAuthDevice(userId, response.authDevice);
      }
    } catch (e) {}
  }

  void _showAuthDevice(String userId, AuthDeviceInfo deviceInfo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).dialogConnectionWithDevice),
          contentPadding: EdgeInsets.all(8.0),
          content: ListTile(
            leading: Icon(
              deviceInfo.deviceType == AuthDeviceInfo_DeviceType.DEVICE_TABLET
                  ? Icons.tablet
                  : Icons.desktop_windows,
            ),
            title: Text(deviceInfo.deviceName),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).actionReject),
              onPressed: () {
                _waitAuthRequestController.add(WaitAuthRequest()
                  ..userId = userId
                  ..authDevice = deviceInfo
                  ..acceptDevice = false);
                _refreshConnectionCode();
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).actionAccept),
              onPressed: () {
                _waitAuthRequestController.add(WaitAuthRequest()
                  ..userId = userId
                  ..authDevice = deviceInfo
                  ..acceptDevice = true);
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _requestConnection(String userId) async {
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

  void _updateProgress() async {
    var userId = await _getUserId();
    setState(() {
      if (_timeLeft == 0) {
        _requestConnection(userId);
        _startTimer();
      } else {
        _timeLeft--;
      }
    });
  }
}
