import 'package:device_info/device_info.dart';
import 'package:fill_memo/bloc/auth/auth_bloc.dart';
import 'package:fill_memo/bloc/auth/auth_state.dart';
import 'package:fill_memo/model/web_auth.dart';
import 'package:fill_memo/service/protobuf/connection.pbgrpc.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/circular_button.dart';
import 'package:fill_memo/widget/icon_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ConnectDeviceScreen extends StatefulWidget {
  @override
  _ConnectDeviceScreenState createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
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
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.titleGuestConnection),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          if (!_isServiceAvailable)
            IconLabel(
              icon: Icons.error,
              text: AppLocalizations.of(context).labelServiceUnavailable,
              backgroundColor: Colors.red,
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: Dimensions.codeTextFieldNormalWidth,
                    child: TextField(
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
                    ),
                  ),
                  SizedBox(height: Dimensions.keylineSmall),
                  CircularButton(
                    icon: Icon(Icons.link),
                    child: Text(
                      localizations.actionConnect,
                    ),
                    outline: true,
                    onPressed: _isServiceAvailable
                        ? () {
                            _requestAuth();
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _requestAuth() async {
    var code = _codeController.value.text;
    if (code.isEmpty) {
      setState(() {
        _codeValidation = false;
      });
      return;
    }

    var authRequest;
    if (kIsWeb) {
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
      context,
      Routes().connectionAuthentication(authRequest),
    );
    if (result.isServiceAvailable) {
      if (result.isSuccess) {
        if (kIsWeb) {
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
}
