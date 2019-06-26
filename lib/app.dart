import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  PreferenceBloc _preferenceBloc;
  SessionBloc _sessionBloc;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _initGlobalBloc();
  }

  void _initGlobalBloc() {
    _preferenceBloc = PreferenceBloc(
      repository: widget.preferenceRepository,
      usagePreferences: AppPreferences.preferences,
    );

    var userIdPref = _preferenceBloc.getPreference(AppPreferences.keyUserId);
    if (userIdPref.value == null) {
      userIdPref.value = Uuid().v4();
      _preferenceBloc.dispatch(UpdatePreference(userIdPref));
    }
    _sessionBloc = SessionBloc(userIdPref.value);

    var darkMode =
        _preferenceBloc.getPreference<bool>(AppPreferences.keyDarkMode).value;
    var initTheme = darkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    _themeBloc = ThemeBloc(initTheme);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<PreferenceBloc>(
          builder: (context) => _preferenceBloc,
          dispose: (context, bloc) => bloc.dispose(),
        ),
        BlocProvider<SessionBloc>(
          builder: (context) => _sessionBloc,
          dispose: (context, bloc) => bloc.dispose(),
        ),
        BlocProvider<ThemeBloc>(
          builder: (context) => _themeBloc,
          dispose: (context, bloc) => bloc.dispose(),
        )
      ],
      child: BlocBuilder<SessionEvent, SessionState>(
          bloc: _sessionBloc,
          builder: (context, sessionState) {
            return BlocProviderTree(
              blocProviders: [
                BlocProvider<MemoBloc>(
                  builder: (context) => MemoBloc(
                    FirebaseMemoRepository(sessionState.userId),
                  )..dispatch(ReadMemo()),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                BlocProvider<FolderBloc>(
                  builder: (context) => FolderBloc(
                    FirebaseFolderRepository(sessionState.userId),
                  )..dispatch(ReadFolder()),
                  dispose: (context, bloc) => bloc.dispose(),
                )
              ],
              child: BlocBuilder<ThemeData, ThemeData>(
                bloc: _themeBloc,
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
                    home: MainScreen(),
                  );
                },
              ),
            );
          }),
    );
  }
}
