import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/bloc/auth/auth_bloc.dart';
import 'package:sp_client/bloc/auth/auth_state.dart';
import 'package:sp_client/model/web_auth.dart';
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
  bool _codeValidation = true;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _buildOnWeb() : _build();
  }

  Widget _build() {
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
              child: Center(
                child: _buildCodeField(),
              ),
            ),
          ),
          _buildBottomButton(themeData, localizations),
        ],
      ),
    );
  }

  Widget _buildOnWeb() {
    var themeData = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).appName,
                  style: themeData.textTheme.title.copyWith(
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 64),
                Text(
                  localizations.labelConnectionCode,
                  style: TextStyle(),
                ),
                SizedBox(height: 8),
                _buildCodeField(),
                SizedBox(height: 32),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 240),
                      child: FlatButton(
                        child: Text(
                          localizations.actionConnect,
                          style: themeData.accentTextTheme.button,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: themeData.accentColor,
                        onPressed: () {
                          _requestAuth(true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (!_isServiceAvailable)
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Card(child: ServiceUnavailableLabel()),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCodeField() {
    return TextField(
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      maxLength: 6,
      maxLengthEnforced: true,
      controller: _codeController,
      decoration: InputDecoration(
        errorText: !_codeValidation
            ? AppLocalizations.of(context).errorEmptyCode
            : null,
      ),
    );
  }

  void _requestAuth([bool runOnWeb = false]) async {
    var code = _codeController.value.text;
    if (code.isEmpty) {
      setState(() {
        _codeValidation = false;
      });
      return;
    }

    var authRequest;
    if (runOnWeb) {
      var currentDeviceInfo = AuthDeviceInfo()
        ..deviceType = AuthDeviceInfo_DeviceType.DEVICE_WEB;

      authRequest = AuthRequest()
        ..connectionCode = code
        ..deviceInfo = currentDeviceInfo;
    } else {
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

      authRequest = AuthRequest()
        ..connectionCode = code
        ..deviceInfo = currentDeviceInfo;
    }

    var result = await Navigator.push(
        context, Routes().connectionAuthentication(authRequest));
    if (result.isServiceAvailable) {
      if (result.isSuccess) {
        if (runOnWeb) {
          var authenticate =
              Provider.of<WebAuthenticate>(context, listen: false);
          authenticate.value = true;
        } else {
          Navigator.pop(context);
        }
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
