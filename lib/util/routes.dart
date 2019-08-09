import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/connection/connect_device_screen.dart';
import 'package:sp_client/screen/connection/connection_authentication_screen.dart';
import 'package:sp_client/screen/connection/connection_authorization_screen.dart';
import 'package:sp_client/screen/connection/generate_code_screen.dart';
import 'package:sp_client/screen/connection/menu_screen.dart';
import 'package:sp_client/screen/connection/profile_screen.dart';
import 'package:sp_client/screen/folder_manage_screen.dart';
import 'package:sp_client/screen/memo_image_screen.dart';
import 'package:sp_client/screen/memo_screen.dart';
import 'package:sp_client/screen/memo_title_screen.dart';
import 'package:sp_client/screen/settings/memo_type_screen.dart';
import 'package:sp_client/screen/settings/settings_screen.dart';
import 'package:sp_client/service/protobuf/connection.pb.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/widget/select_folder_dialog.dart';

class Routes {
  PageRoute memoTitle(String memoType) {
    return MaterialPageRoute(builder: (context) => MemoTitleScreen(memoType));
  }

  PageRoute memo(Memo memo) {
    return MaterialPageRoute(builder: (context) => MemoScreen(memo));
  }

  PageRoute memoImage({List<String> contentImages, int initIndex}) {
    return MaterialPageRoute(
      builder: (context) => MemoImageScreen(
        contentImages: contentImages,
        initIndex: initIndex,
      ),
    );
  }

  PageRoute folderManage({MemoBloc memoBloc, FolderBloc folderBloc}) {
    return MaterialPageRoute(
      builder: (context) => FolderManageScreen(),
    );
  }

  PageRoute selectFolder() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => SelectFolderDialog(),
    );
  }

  AlertDialog selectFolderDialog(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).dialogFolderSelect),
      contentPadding: EdgeInsets.all(16.0),
      content: Container(
        width: 360.0,
        height: 160.0,
        child: SelectFolderDialog(),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  PageRoute connectionMenu = MaterialPageRoute(
    builder: (context) => ConnectionMenuScreen(),
  );

  PageRoute connectionProfile = MaterialPageRoute(
    builder: (context) => ConnectionProfileScreen(),
  );

  PageRoute connectionGenerateCode = MaterialPageRoute(
    builder: (context) => GenerateCodeScreen(),
  );

  PageRoute connectionAuthorization(WaitAuthResponse response) {
    return MaterialPageRoute(
      builder: (context) => ConnectionAuthorizationScreen(response),
    );
  }

  PageRoute connectionAuthentication(AuthRequest request) {
    return MaterialPageRoute(
      builder: (context) => ConnectionAuthenticationScreen(request),
    );
  }

  PageRoute connectionConnectDevice = MaterialPageRoute(
    builder: (context) => ConnectDeviceScreen(),
  );

  PageRoute settings = MaterialPageRoute(
    builder: (context) => SettingsScreen(),
  );

  PageRoute settingsMemoType(PreferenceBloc preferenceBloc) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<PreferenceBloc>.value(
        value: preferenceBloc,
        child: SettingsMemoTypeScreen(),
      ),
    );
  }
}
