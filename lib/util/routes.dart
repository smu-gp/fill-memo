import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/folder_manage_screen.dart';
import 'package:sp_client/screen/memo_image_screen.dart';
import 'package:sp_client/screen/memo_screen.dart';
import 'package:sp_client/screen/memo_title_screen.dart';
import 'package:sp_client/screen/settings/settings_memo_type_screen.dart';
import 'package:sp_client/screen/settings/settings_screen.dart';
import 'package:sp_client/widget/select_folder_dialog.dart';

class Routes {
  PageRoute memoTitle(BuildContext context, String memoType) {
    var memoBloc = BlocProvider.of<MemoBloc>(context);
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MemoBloc>.value(value: memoBloc),
            BlocProvider<FolderBloc>.value(value: folderBloc),
          ],
          child: MemoTitleScreen(memoType),
        );
      },
    );
  }

  PageRoute memo(BuildContext context, Memo memo) {
    var memoBloc = BlocProvider.of<MemoBloc>(context);
    return MaterialPageRoute(builder: (context) {
      return BlocProvider<MemoBloc>.value(
        value: memoBloc,
        child: MemoScreen(memo),
      );
    });
  }

  PageRoute memoImage({List<String> contentImages, int initIndex}) {
    return MaterialPageRoute(builder: (context) {
      return MemoImageScreen(
        contentImages: contentImages,
        initIndex: initIndex,
      );
    });
  }

  PageRoute folderManage({MemoBloc memoBloc, FolderBloc folderBloc}) {
    return MaterialPageRoute(
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MemoBloc>.value(value: memoBloc),
            BlocProvider<FolderBloc>.value(value: folderBloc),
          ],
          child: FolderManageScreen(),
        );
      },
    );
  }

  PageRoute selectFolder(BuildContext context) {
    var folderBloc = BlocProvider.of<FolderBloc>(context);
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider<FolderBloc>.value(
        value: folderBloc,
        child: SelectFolderDialog(),
      ),
    );
  }

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
