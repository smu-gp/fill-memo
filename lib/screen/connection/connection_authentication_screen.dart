import 'dart:async';

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/service/protobuf/connection.pb.dart';
import 'package:fill_memo/service/protobuf/connection.pbgrpc.dart';
import 'package:fill_memo/service/services.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/circular_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectionAuthenticationScreen extends StatefulWidget {
  final AuthRequest authRequest;

  ConnectionAuthenticationScreen(this.authRequest);

  @override
  _ConnectionAuthenticationScreenState createState() =>
      _ConnectionAuthenticationScreenState();
}

class _ConnectionAuthenticationScreenState
    extends State<ConnectionAuthenticationScreen> {
  ConnectionServiceClient _client;
  PreferenceRepository _preferenceRepository;

  StreamController<AuthResponse> _authResController = StreamController();

  Stream get _authResStream => _authResController.stream;

  String get userId =>
      _preferenceRepository.getString(AppPreferences.keyUserId);

  String get host =>
      _preferenceRepository.getString(AppPreferences.keyServiceHost) ??
      defaultServiceHost;

  bool isConnection = true;

  @override
  void initState() {
    super.initState();
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _client = createConnectionClient(host: host);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isConnection;
      },
      child: Scaffold(
        body: Center(
          child: StreamBuilder<AuthResponse>(
              stream: _authResStream,
              builder: (context, snapshot) {
                var children;
                if (snapshot.hasData) {
                  var response = snapshot.data;
                  children = _buildResponseResult(response);
                } else {
                  children = <Widget>[
                    CircularProgressIndicator(),
                    Text(AppLocalizations.of(context).labelWaitHostResponse),
                  ];
                }
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 24,
                  direction: Axis.vertical,
                  children: children,
                );
              }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authResController.close();
    super.dispose();
  }

  Future _requestAuth() async {
    try {
      var response = await _client.auth(widget.authRequest);
      _authResController.sink.add(response);
      if (response.message == AuthResponse_ResultMessage.MESSAGE_SUCCESS) {
        BlocProvider.of<AuthBloc>(context)
            .dispatch(ChangedUser(response.userId));
      }
    } catch (_) {
      Navigator.pop(context, AuthenticationResult.unavailable());
    }
  }

  List<Widget> _buildResponseResult(AuthResponse response) {
    if (response.message == AuthResponse_ResultMessage.MESSAGE_SUCCESS) {
      if (kIsWeb) {
        Navigator.pop(context, AuthenticationResult.success());
        return <Widget>[
          Container(),
        ];
      } else {
        return <Widget>[
          Icon(Icons.check_circle, color: Colors.green, size: 72),
          Text(AppLocalizations.of(context).labelConnectSuccess),
          CircularButton(
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
            outline: true,
            onPressed: () {
              Navigator.pop(context, AuthenticationResult.success());
            },
          )
        ];
      }
    } else {
      return <Widget>[
        Icon(Icons.error, color: Colors.red, size: 72),
        Text(_toStringFromReason(response.failedReason)),
        CircularButton(
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          outline: true,
          onPressed: () {
            Navigator.pop(context, AuthenticationResult.failed());
          },
        )
      ];
    }
  }

  String _toStringFromReason(AuthResponse_FailedReason reason) {
    switch (reason) {
      case AuthResponse_FailedReason.AUTH_FAILED:
        return AppLocalizations.of(context).labelAuthFailed;
      case AuthResponse_FailedReason.RESPONSE_TIMEOUT:
        return AppLocalizations.of(context).labelResponseTimeout;
      case AuthResponse_FailedReason.REJECT_HOST:
        return AppLocalizations.of(context).labelRejectHost;
      case AuthResponse_FailedReason.NO_HOST_WAITED:
        return AppLocalizations.of(context).labelNoHostWaited;
      case AuthResponse_FailedReason.INTERNAL_ERR:
        return AppLocalizations.of(context).labelInternalErr;
      case AuthResponse_FailedReason.NONE:
        return AppLocalizations.of(context).labelNone;
      default:
        return '';
    }
  }
}

class AuthenticationResult {
  bool isServiceAvailable;
  bool isSuccess;

  AuthenticationResult(this.isServiceAvailable, this.isSuccess);

  factory AuthenticationResult.unavailable() {
    return AuthenticationResult(false, false);
  }

  factory AuthenticationResult.success() {
    return AuthenticationResult(true, true);
  }

  factory AuthenticationResult.failed() {
    return AuthenticationResult(true, false);
  }

  @override
  String toString() =>
      "$runtimeType(isServiceAvailable: $isServiceAvailable, isSuccess: $isSuccess)";
}
