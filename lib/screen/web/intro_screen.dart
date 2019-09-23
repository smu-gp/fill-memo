import 'package:device_info/device_info.dart';
import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/service/protobuf/connection.pb.dart';
import 'package:fill_memo/util/dimensions.dart';
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
  FocusNode _codeFocusNode = FocusNode();

  AuthBloc _authBloc;

  bool _isServiceAvailable = true;
  bool _codeValidation = true;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _codeFocusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Widget introImage = Container(
      child: Image.asset("res/images/undraw_in_sync.png"),
    );

    Widget introField = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).appName,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).labelDeviceConnect,
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).textTheme.caption.color,
              ),
        ),
        Expanded(child: Container()),
        _CodeField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          isCodeValid: _codeValidation,
        ),
        Expanded(child: Container()),
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonMinWidth: 96.0,
          buttonTextTheme: ButtonTextTheme.accent,
          children: <Widget>[
            FlatButton(
              child: Text(
                AppLocalizations.of(context).connectionCodeHelp,
              ),
              onPressed: () {
                _showHelpDialog();
              },
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                AppLocalizations.of(context).actionConnect,
              ),
              textColor: Colors.white,
              onPressed: () {
                _requestAuth();
              },
              color: Theme.of(context).accentColor,
            ),
          ],
        ),
      ],
    );

    Widget content;

    if (_isLargeScreen()) {
      content = SizedBox(
        width: 720.0,
        height: 360.0,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: introImage,
              ),
              VerticalDivider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: introField,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      content = SizedBox(
        width: 480.0,
        height: 720.0,
        child: Column(
          children: <Widget>[
            Expanded(child: introImage),
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: introField,
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: _isLargeScreen() ? null : Colors.white,
      body: Stack(
        children: <Widget>[
          Center(child: content),
          if (!_isServiceAvailable)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 360.0,
                child: Card(
                  child: IconLabel(
                    icon: Icons.error,
                    text: AppLocalizations.of(context).labelServiceUnavailable,
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isLargeScreen() {
    var size = MediaQuery.of(context).size;
    return size.width > 960;
  }

  void _showHelpDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).connectionCodeHelp),
          content: Container(
            width: Dimensions.dialogWidth(context),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: [
                  TextSpan(
                      text: AppLocalizations.of(context).connectionCodePrefix),
                  TextSpan(
                    text: AppLocalizations.of(context).connectionCodeNavigate,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text: AppLocalizations.of(context).connectionCodeSuffix),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
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

class _CodeField extends StatefulWidget {
  final TextEditingController controller;
  final bool isCodeValid;
  final FocusNode focusNode;

  _CodeField({
    Key key,
    this.focusNode,
    this.controller,
    this.isCodeValid,
  }) : super(key: key);

  @override
  _CodeFieldState createState() => _CodeFieldState();
}

class _CodeFieldState extends State<_CodeField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      maxLength: 6,
      maxLengthEnforced: true,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        filled: true,
        labelText: AppLocalizations.of(context).labelConnectionCode,
        labelStyle: widget.focusNode.hasFocus && widget.isCodeValid
            ? TextStyle(color: Theme.of(context).accentColor)
            : null,
        errorText: !widget.isCodeValid
            ? AppLocalizations.of(context).errorEmptyCode
            : null,
      ),
    );
  }
}
