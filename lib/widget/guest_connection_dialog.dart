import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/service/grpc_service.dart';
import 'package:sp_client/service/protobuf/connection.pb.dart';
import 'package:sp_client/service/protobuf/connection.pbenum.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/timer_text.dart';

enum _AuthState { none, waitResponse, success, failed }

class GuestConnectionDialog extends StatefulWidget {
  @override
  _GuestConnectionDialogState createState() => _GuestConnectionDialogState();
}

class _GuestConnectionDialogState extends State<GuestConnectionDialog> {
  final _timerTextKey = GlobalKey<TimerTextState>();
  final _textController = TextEditingController();

  PreferenceBloc _preferenceBloc;
  GrpcService _grpcService;

  String _connectUserId;
  _AuthState _authState = _AuthState.none;
  AuthResponse_FailedReason _failedReason;

  @override
  void initState() {
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    _grpcService = GrpcService(
      host: _preferenceBloc.getPreference(AppPreferences.keyServiceHost).value,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).titleGuestConnection),
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: 480.0,
        height: 240.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildContent(),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            MaterialLocalizations.of(context).closeButtonLabel,
          ),
        ),
        if (_authState == _AuthState.none)
          FlatButton(
            onPressed: _requestAuth,
            child: Text(
              AppLocalizations.of(context).actionConnect.toUpperCase(),
            ),
          ),
        if (_authState == _AuthState.failed)
          FlatButton(
            child: Text(
              AppLocalizations.of(context).actionRetry.toUpperCase(),
            ),
            onPressed: () {
              _textController.clear();
              setState(() {
                _authState = _AuthState.none;
              });
            },
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (_authState == _AuthState.none) {
      return Center(
        child: TextField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            filled: true,
            fillColor: Theme.of(context).primaryColorDark,
          ),
          controller: _textController,
          minLines: 1,
          maxLength: 6,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
        ),
      );
    } else if (_authState == _AuthState.waitResponse) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context).labelWaitHostResponse),
          ),
          TimerText(
            key: _timerTextKey,
            duration: Duration(minutes: 1),
          ),
        ],
      );
    } else if (_authState == _AuthState.success) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: 72.0,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context).labelConnectSuccess,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 72.0,
            color: Theme.of(context).accentColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              AppLocalizations.of(context).labelConnectFailed,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          if (_failedReason != null)
            Text(_getFailedReasonMessage(_failedReason)),
        ],
      );
    }
  }

  void _requestAuth() async {
    setState(() {
      _authState = _AuthState.waitResponse;
    });

    var connectionCode = _textController.value.text;
    if (connectionCode.isEmpty) {
      setState(() {
        _authState = _AuthState.none;
      });
      return;
    }

    var deviceName;
    var deviceType;
    if (Platform.isAndroid) {
      var info = await DeviceInfoPlugin().androidInfo;
      deviceName = info.model;
      deviceType = AuthDeviceInfo_DeviceType.DEVICE_TABLET;
    } else if (Platform.isIOS) {
      var info = await DeviceInfoPlugin().iosInfo;
      deviceName = info.utsname.machine;
      deviceType = AuthDeviceInfo_DeviceType.DEVICE_TABLET;
    } else {
      deviceName = 'Unknown';
      deviceType = AuthDeviceInfo_DeviceType.DEVICE_WEB;
    }

    var deviceInfo = AuthDeviceInfo()
      ..deviceName = deviceName
      ..deviceType = deviceType;

    var authResponse = await _grpcService.connectionServiceClient.auth(
        AuthRequest()
          ..connectionCode = connectionCode
          ..deviceInfo = deviceInfo,
        options: CallOptions(
          timeout: Duration(seconds: 70),
        ));

    if (_timerTextKey.currentState != null) {
      _timerTextKey.currentState.cancelTimer();
    }

    if (authResponse.message == AuthResponse_ResultMessage.MESSAGE_SUCCESS) {
      var preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
      var currentUserId = preferenceBloc
          .getPreference<String>(
            AppPreferences.keyUserId,
          )
          .value;
      var responseUserId = authResponse.userId;

      if (currentUserId != responseUserId) {
        setState(() {
          _authState = _AuthState.success;
          _connectUserId = authResponse.userId;
        });
      } else {
        setState(() {
          _authState = _AuthState.failed;
        });
      }
    } else {
      setState(() {
        _authState = _AuthState.failed;
        _failedReason = authResponse.failedReason;
      });
    }
  }

  String _getFailedReasonMessage(AuthResponse_FailedReason failedReason) {
    switch (failedReason) {
      case AuthResponse_FailedReason.NONE:
        return AppLocalizations.of(context).labelNone;
      case AuthResponse_FailedReason.AUTH_FAILED:
        return AppLocalizations.of(context).labelAuthFailed;
      case AuthResponse_FailedReason.INTERNAL_ERR:
        return AppLocalizations.of(context).labelInternalErr;
      case AuthResponse_FailedReason.REJECT_HOST:
        return AppLocalizations.of(context).labelRejectHost;
      case AuthResponse_FailedReason.NO_HOST_WAITED:
        return AppLocalizations.of(context).labelNoHostWaited;
      case AuthResponse_FailedReason.RESPONSE_TIMEOUT:
        return AppLocalizations.of(context).labelResponseTimeout;
      default:
        return "";
    }
  }
}
