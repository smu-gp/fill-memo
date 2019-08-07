import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/auth/auth_bloc.dart';
import 'package:sp_client/bloc/auth/auth_state.dart';
import 'package:sp_client/service/protobuf/connection.pbgrpc.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/service_unavailable_label.dart';

class ConnectDeviceScreen extends StatefulWidget {
  @override
  _ConnectDeviceScreenState createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final TextEditingController _codeController = TextEditingController();

  AuthBloc _authBloc;

  bool _isServiceAvailable = true;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(localizations.titleGuestConnection),
        elevation: 0,
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
                  TextField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: localizations.labelConnectionCode,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: 6,
                    maxLengthEnforced: true,
                    controller: _codeController,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(themeData, localizations),
        ],
      ),
    );
  }

  void _requestAuth() async {
    var code = _codeController.value.text;
    if (code.isEmpty) {
      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).errorEmptyCode),
        ));
      return;
    }

    var authState = _authBloc.currentState;
    if (authState is Unauthenticated) {
      return;
    }

    var deviceInfo = await DeviceInfoPlugin().androidInfo;
    var modelName = deviceInfo.model;

    var displayName = (authState as Authenticated).displayName ?? "";

    var currentDeviceInfo = AuthDeviceInfo()
      ..deviceType = AuthDeviceInfo_DeviceType.DEVICE_ANDROID
      ..deviceName = "$displayName|$modelName";

    var authRequest = AuthRequest()
      ..connectionCode = code
      ..deviceInfo = currentDeviceInfo;

    var result = await Navigator.push(
        context, Routes().connectionAuthentication(authRequest));
    if (result.isServiceAvailable) {
      if (result.isSuccess) {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _isServiceAvailable = false;
      });
    }
  }

  Widget _buildBottomButton(ThemeData theme, AppLocalizations localizations) {
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
                Icons.link,
                color: theme.accentIconTheme.color,
              ),
              SizedBox(width: 8),
              Text(
                localizations.actionConnect,
                style: theme.accentTextTheme.button,
              ),
            ],
          ),
        ),
        onTap: _isServiceAvailable ? _requestAuth : null,
      ),
    );
  }
}
