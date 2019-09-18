import 'dart:async';

import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/service/protobuf/connection.pbgrpc.dart';
import 'package:fill_memo/service/services.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/circular_button.dart';
import 'package:fill_memo/widget/icon_label.dart';
import 'package:fill_memo/widget/timer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _client = createConnectionClient(host: host);

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
          if (!_isServiceAvailable)
            IconLabel(
              icon: Icons.error,
              text: AppLocalizations.of(context).labelServiceUnavailable,
              backgroundColor: Colors.red,
            ),
          if (_isServiceAvailable)
            IconLabel(
              icon: Icons.warning,
              text: AppLocalizations.of(context).warnGenerateCode,
              backgroundColor: Colors.orange,
            ),
          Expanded(
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
                SizedBox(height: Dimensions.keylineSmall),
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
                SizedBox(height: Dimensions.keylineSmall),
                CircularButton(
                  icon: Icon(Icons.refresh),
                  child: Text(
                    MaterialLocalizations.of(context)
                        .refreshIndicatorSemanticLabel,
                  ),
                  outline: true,
                  onPressed: _isServiceAvailable
                      ? () {
                          _requestCode();
                        }
                      : null,
                )
              ],
            ),
          ),
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

  Widget _buildWarnMsg() {
    return Container(
      height: 48.0,
      color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning),
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
