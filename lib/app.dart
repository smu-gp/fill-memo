import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/screen/init_screen.dart';
import 'package:uuid/uuid.dart';

import 'bloc/blocs.dart';
import 'repository/repositories.dart';
import 'screen/main_screen.dart';
import 'util/utils.dart';

class App extends StatefulWidget {
  final PreferenceRepository preferenceRepository;

  App({
    Key key,
    @required this.preferenceRepository,
  })  : assert(preferenceRepository != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  String _userId;
  ThemeBloc _themeBloc;
  AuthBloc _authBloc;
  MemoBloc _memoBloc;
  FolderBloc _folderBloc;

  UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _userId = widget.preferenceRepository.getString(
      AppPreferences.keyUserId,
    );
    if (_userId == null) {
      _userId = Uuid().v4();
      widget.preferenceRepository.setString(AppPreferences.keyUserId, _userId);
    }

    _userRepository = FirebaseUserRepository();

    var darkMode =
        widget.preferenceRepository.getBool(AppPreferences.keyDarkMode);
    var initTheme =
        (darkMode ?? false) ? AppThemes.darkTheme : AppThemes.lightTheme;

    _themeBloc = ThemeBloc(initTheme);

    _authBloc = AuthBloc(
      userRepository: _userRepository,
    )..dispatch(AppStarted(_userId));

    _memoBloc = MemoBloc(
      memoRepository: FirebaseMemoRepository(),
    );
    _folderBloc = FolderBloc(
      folderRepository: FirebaseFolderRepository(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>.value(
          value: _themeBloc,
        ),
        BlocProvider<AuthBloc>.value(
          value: _authBloc,
        ),
        BlocProvider<MemoBloc>.value(
          value: _memoBloc,
        ),
        BlocProvider<FolderBloc>.value(
          value: _folderBloc,
        ),
      ],
      child: RepositoryProvider<PreferenceRepository>.value(
        value: widget.preferenceRepository,
        child: BlocBuilder<ThemeBloc, ThemeData>(
          builder: (context, themeState) {
            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appName,
              theme: themeState,
              darkTheme: AppThemes.darkTheme,
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'),
                const Locale('ko', 'KR'),
              ],
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  if (authState is Authenticated) {
                    _memoBloc.dispatch(UpdateMemoUser(authState.uid));
                    _folderBloc.dispatch(UpdateFolderUser(authState.uid));
                    return MainScreen();
                  } else {
                    return BlocProvider(
                      builder: (context) =>
                          LoginBloc(userRepository: _userRepository),
                      child: InitScreen(userId: _userId),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
