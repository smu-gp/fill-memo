import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/screen/connection/connect_device_screen.dart';
import 'package:fill_memo/screen/connection/connection_authentication_screen.dart';
import 'package:fill_memo/screen/connection/connection_authorization_screen.dart';
import 'package:fill_memo/screen/connection/generate_code_screen.dart';
import 'package:fill_memo/screen/connection/menu_screen.dart';
import 'package:fill_memo/screen/connection/profile_screen.dart';
import 'package:fill_memo/screen/folder_manage_screen.dart';
import 'package:fill_memo/screen/memo_image_screen.dart';
import 'package:fill_memo/screen/memo_markdown_preview_screen.dart';
import 'package:fill_memo/screen/memo_markdown_screen.dart';
import 'package:fill_memo/screen/memo_screen.dart';
import 'package:fill_memo/screen/memo_screen_handwriting.dart';
import 'package:fill_memo/screen/memo_title_screen.dart';
import 'package:fill_memo/screen/settings/memo_type_screen.dart';
import 'package:fill_memo/screen/settings/settings_screen.dart';
import 'package:fill_memo/service/protobuf/connection.pb.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/widget/select_folder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';

class Routes {
  PageRoute memoTitle(String memoType) {
    return MaterialPageRoute(builder: (context) => MemoTitleScreen(memoType));
  }

  PageRoute memo(Memo memo) {
    var dest;
    if (memo.type == typeRichText) {
      dest = MemoScreen(memo);
    } else if (memo.type == typeHandWriting) {
      dest = MemoHandwritingScreen(memo);
    } else if (memo.type == typeMarkdown) {
      dest = MemoMarkdownScreen(memo);
    }
    return MaterialPageRoute(builder: (context) => dest);
  }

  PageRoute memoImage({
    List<String> contentImages,
    int initIndex,
    String heroTagId,
  }) {
    return MaterialPageRoute(
      builder: (context) => MemoImageScreen(
        contentImages: contentImages,
        initIndex: initIndex,
        heroTagId: heroTagId,
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
        width: Dimensions.dialogWidth(context),
        height: Dimensions.dialogListHeight,
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

  PageRoute markdownPreviewMemo({String title, String content}) {
    return MaterialPageRoute(
      builder: (context) => MemoMarkdownPreviewScreen(
        title: title,
        content: content,
      ),
    );
  }
}
