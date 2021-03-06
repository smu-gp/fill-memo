import 'package:fill_memo/service/protobuf/connection.pb.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/widget/circular_button.dart';
import 'package:flutter/material.dart';

class ConnectionAuthorizationScreen extends StatelessWidget {
  final WaitAuthResponse waitAuthResponse;

  ConnectionAuthorizationScreen(this.waitAuthResponse);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var localization = AppLocalizations.of(context);

    var deviceInfo = waitAuthResponse.authDevice;
    var deviceType = deviceInfo.deviceType;

    var deviceName;
    var deviceIcon;
    var isWebConnection = false;
    if (deviceType == AuthDeviceInfo_DeviceType.DEVICE_ANDROID) {
      var separateName = deviceInfo.deviceName.split("|");
      if (separateName[0].isEmpty) {
        deviceName = separateName[1];
      } else {
        deviceName = localization.deviceName(separateName[0], separateName[1]);
      }
      deviceIcon = Icons.android;
    } else if (deviceType == AuthDeviceInfo_DeviceType.DEVICE_WEB) {
      isWebConnection = true;
      deviceName = deviceInfo.deviceName;
      deviceIcon = Icons.public;
    } else {
      deviceName = deviceInfo.deviceName;
      deviceIcon = Icons.device_unknown;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          direction: Axis.vertical,
          children: <Widget>[
            CircleAvatar(
              child: Icon(deviceIcon, size: 48),
              radius: 48,
              backgroundColor: themeData.accentColor,
            ),
            SizedBox(height: 8),
            Text(isWebConnection
                ? localization.labelWebConnectionRequest
                : localization.labelConnectionRequest(deviceName)),
            ButtonBar(
              children: <Widget>[
                CircularButton(
                  child: Text(localization.actionReject),
                  outline: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                CircularButton(
                  child: Text(
                    localization.actionAccept,
                    style: themeData.accentTextTheme.button,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
