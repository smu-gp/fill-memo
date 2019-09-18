import 'package:device_info/device_info.dart';
import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/service/protobuf/connection.pb.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/routes.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/icon_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WebIntroScreen extends StatefulWidget {
  @override
  _WebIntroScreenState createState() => _WebIntroScreenState();
}

class _WebIntroScreenState extends State<WebIntroScreen> {
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
    Widget child = Wrap(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.keylineLarge,
            horizontal: Dimensions.keylineXLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Dimensions.iconSize,
                height: Dimensions.iconSize,
                color: Colors.grey,
              ),
              SizedBox(height: Dimensions.keyline),
              Text(
                AppLocalizations.of(context).appName,
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: Dimensions.keylineLarge),
              Text(
                AppLocalizations.of(context).labelConnectionCode,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: Dimensions.keylineSmall),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                maxLengthEnforced: true,
                controller: _codeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                  isDense: true,
                  filled: false,
                  errorText: !_codeValidation
                      ? AppLocalizations.of(context).errorEmptyCode
                      : null,
                ),
              ),
              SizedBox(height: Dimensions.keylineLarge),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.keyline,
                      vertical: Dimensions.keylineSmall,
                    ),
                    child: Text(
                      AppLocalizations.of(context).actionConnect,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () {
                    _requestAuth();
                  },
                ),
              ),
            ],
          ),
        ),
        if (!_isServiceAvailable && Util.isLarge(context))
          IconLabel(
            icon: Icons.error,
            text: AppLocalizations.of(context).labelServiceUnavailable,
            backgroundColor: Colors.red,
          ),
      ],
    );

    if (Util.isLarge(context)) {
      child = Center(
        child: Container(
          width: Dimensions.introCardWidth(context),
          child: Card(
            elevation: 4.0,
            child: child,
          ),
        ),
      );
    } else {
      child = Column(
        children: <Widget>[
          Expanded(
            child: Center(child: child),
          ),
          if (!_isServiceAvailable)
            IconLabel(
              icon: Icons.error,
              text: AppLocalizations.of(context).labelServiceUnavailable,
              backgroundColor: Colors.red,
            ),
        ],
      );
    }

    return Scaffold(
      backgroundColor:
          Util.isLarge(context) ? Theme.of(context).accentColor : null,
      body: child,
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
