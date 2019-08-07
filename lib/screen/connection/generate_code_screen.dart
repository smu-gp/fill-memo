import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/service/grpc_service.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/service_unavailable_label.dart';
import 'package:sp_client/widget/timer_text.dart';

class GenerateCodeScreen extends StatefulWidget {
  @override
  _GenerateCodeScreenState createState() => _GenerateCodeScreenState();
}

class _GenerateCodeScreenState extends State<GenerateCodeScreen> {
  final GlobalKey<TimerTextState> _timerKey = GlobalKey();

  ConnectionServiceClient _client;
  PreferenceRepository _preferenceRepository;

  StreamController<String> _codeController = StreamController();
  StreamController<WaitAuthRequest> _waitAuthReqController = StreamController();

  StreamSubscription _waitAuthResSubscription;

  String get userId =>
      _preferenceRepository.getString(AppPreferences.keyUserId);

  String get host =>
      _preferenceRepository.getString(AppPreferences.keyServiceHost) ??
      defaultServiceHost;

  Stream get _codeStream => _codeController.stream;

  Stream get _authReqStream => _waitAuthReqController.stream;

  bool _isServiceAvailable = true;

  @override
  void initState() {
    super.initState();
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _client = GrpcService(host: host).connectionServiceClient;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _waitAuth();
      _requestCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(localizations.titleHostConnection),
      ),
      body: Column(
        children: <Widget>[
          if (!_isServiceAvailable) ServiceUnavailableLabel(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TimerText(
                    key: _timerKey,
                    duration: Duration(seconds: 59),
                    color: themeData.accentColor,
                    warnColor: Colors.red,
                    onChanged: (duration) {
                      if (duration.inSeconds == 0) {
                        _requestCode();
                      }
                    },
                  ),
                  SizedBox(height: 4),
                  StreamBuilder<String>(
                    stream: _codeStream,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.hasData ? snapshot.data : '000000',
                        style: TextStyle(
                          fontSize: 40,
                          letterSpacing: 8,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildWarnMsg(),
          SizedBox(height: 4),
          _buildBottomButton(themeData),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController.close();
    _waitAuthReqController.close();
    _waitAuthResSubscription?.cancel();
    super.dispose();
  }

  void _requestCode() async {
    try {
      var response = await _client.connection(
        ConnectionRequest()..userId = userId,
      );
      _codeController.sink.add(response.connectionCode);
      _timerKey.currentState.startTimer();
    } catch (err) {
      debugPrint(err.toString());
      setState(() {
        _isServiceAvailable = false;
      });
    }
  }

  void _waitAuth() {
    var waitAuthRequest = WaitAuthRequest()..userId = userId;
    var waitAuthStream = _client.waitAuth(_authReqStream);
    _waitAuthReqController.sink.add(waitAuthRequest);
    _waitAuthResSubscription = waitAuthStream.listen((response) async {
      var isAccept = await Navigator.push(
              context, Routes().connectionAuthorization(response)) ??
          false;
      if (isAccept) {
        Navigator.pop(context);
      } else {
        _requestCode();
      }
      waitAuthRequest
        ..authDevice = response.authDevice
        ..acceptDevice = isAccept;
      _waitAuthReqController.sink.add(waitAuthRequest);
    });
    _waitAuthResSubscription.onError((err) {
      debugPrint(err.toString());
      setState(() {
        _isServiceAvailable = false;
      });
    });
  }

  Widget _buildBottomButton(ThemeData theme) {
    return Material(
      color: _isServiceAvailable ? theme.accentColor : theme.disabledColor,
      child: InkWell(
        child: Container(
          width: double.infinity,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.refresh,
                color: theme.accentIconTheme.color,
              ),
              SizedBox(width: 8),
              Text(
                MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
                style: theme.accentTextTheme.button,
              ),
            ],
          ),
        ),
        onTap: _isServiceAvailable ? _requestCode : null,
      ),
    );
  }

  Widget _buildWarnMsg() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning, color: Colors.yellow[700]),
            SizedBox(width: 24),
            Expanded(
              child: Text(
                AppLocalizations.of(context).warnGenerateCode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
