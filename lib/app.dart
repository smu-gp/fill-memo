import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uuid/uuid.dart';

import 'bloc/blocs.dart';
import 'repository/repositories.dart';
import 'screen/main_screen.dart';
import 'util/utils.dart';

class App extends StatefulWidget {
  final HistoryRepository historyRepository;
  final ResultRepository resultRepository;
  final FolderRepository folderRepository;
  final PreferenceRepository preferenceRepository;

  App({
    Key key,
    @required this.historyRepository,
    @required this.resultRepository,
    @required this.folderRepository,
    @required this.preferenceRepository,
  })  : assert(historyRepository != null),
        assert(resultRepository != null),
        assert(folderRepository != null),
        assert(preferenceRepository != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  PreferenceBloc _preferenceBloc;
  ThemeBloc _themeBloc;

  SystemUiOverlayStyle _latestStyle;

  @override
  void initState() {
    super.initState();
    _preferenceBloc = PreferenceBloc(
      repository: widget.preferenceRepository,
      usagePreferences: AppPreferences.preferences,
    );

    var darkMode =
        _preferenceBloc.getPreference<bool>(AppPreferences.keyDarkMode).value;
    var initTheme = darkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    _themeBloc = ThemeBloc(initTheme);

    _latestStyle = SystemUiOverlayStyle.light;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<HistoryBloc>(
          builder: (context) {
            return HistoryBloc(repository: widget.historyRepository);
          },
          dispose: (context, bloc) => bloc.dispose(),
        ),
        BlocProvider<ResultBloc>(
          builder: (context) {
            return ResultBloc(repository: widget.resultRepository);
          },
          dispose: (context, bloc) => bloc.dispose(),
        ),
        BlocProvider<FolderBloc>(
          builder: (context) {
            return FolderBloc(repository: widget.folderRepository);
          },
          dispose: (context, bloc) => bloc.dispose(),
        ),
        BlocProvider<PreferenceBloc>(
          builder: (context) => _preferenceBloc,
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ],
      child: BlocProvider<ThemeBloc>(
        builder: (context) => _themeBloc,
        child: BlocBuilder<ThemeData, ThemeData>(
          bloc: _themeBloc,
          builder: (context, state) {
            _latestStyle = _latestStyle.copyWith(
              systemNavigationBarColor: state.accentColor,
            );
            SystemChrome.setSystemUIOverlayStyle(_latestStyle);

            return MaterialApp(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context).appName,
              theme: state,
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
        dispose: (context, bloc) => bloc.dispose(),
      ),
    );
  }
}
