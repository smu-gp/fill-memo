import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/model/local_auth.dart';
import 'package:sp_client/util/localization.dart';

class LocalAuthScreen extends StatefulWidget {
  @override
  _LocalAuthScreenState createState() => _LocalAuthScreenState();
}

class _LocalAuthScreenState extends State<LocalAuthScreen> {
  bool _authenticateFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _requestAuthenticate();
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          direction: Axis.vertical,
          children: <Widget>[
            CircleAvatar(
              child: Icon(Icons.fingerprint, size: 48),
              radius: 48,
              backgroundColor:
                  _authenticateFailed ? Colors.red[500] : themeData.accentColor,
            ),
            SizedBox(height: 8),
            Text(_authenticateFailed
                ? localizations.androidFingerprintNotRecognized
                : localizations.labelFingerprint),
            FlatButton(
              child: Text(localizations.actionRetry),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: themeData.colorScheme.onSurface.withOpacity(0.12),
                ),
              ),
              onPressed: () => _requestAuthenticate(),
            )
          ],
        ),
      ),
    );
  }

  Future _requestAuthenticate() async {
    var localizations = AppLocalizations.of(context);
    var messages = AndroidAuthMessages(
      fingerprintHint: localizations.androidFingerprintHint,
      fingerprintNotRecognized: localizations.androidFingerprintNotRecognized,
      fingerprintSuccess: localizations.androidFingerprintSuccess,
      cancelButton: localizations.androidCancelButton,
      signInTitle: localizations.androidSignInTitle,
      fingerprintRequiredTitle: localizations.androidFingerprintRequiredTitle,
      goToSettingsButton: localizations.goToSettings,
      goToSettingsDescription: localizations.androidGoToSettingsDescription,
    );
    var localAuth = LocalAuthentication();
    bool authenticated = await localAuth.authenticateWithBiometrics(
      localizedReason: localizations.authenticatedReason,
      stickyAuth: true,
      androidAuthStrings: messages,
    );
    if (authenticated) {
      var authState = Provider.of<LocalAuthenticate>(context, listen: false);
      authState.authenticated = true;
    } else {
      setState(() {
        _authenticateFailed = true;
      });
    }
  }
}
