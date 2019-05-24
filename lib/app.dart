import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/screen/main_screen.dart';
import 'package:sp_client/util/utils.dart';

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
  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  FolderBloc _folderBloc;
  ThemeBloc _themeBloc;
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc(repository: widget.historyRepository);
    _resultBloc = ResultBloc(repository: widget.resultRepository);
    _folderBloc = FolderBloc(repository: widget.folderRepository);
    _preferenceBloc = PreferenceBloc(
      repository: widget.preferenceRepository,
      usagePreferences: AppPreferences.preferences,
    );

    var lightTheme =
        widget.preferenceRepository.getBool(AppPreferences.keyLightTheme);
    var initTheme = !lightTheme ? AppThemes.defaultTheme : AppThemes.lightTheme;
    _themeBloc = ThemeBloc(initTheme);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<HistoryBloc>(bloc: _historyBloc),
        BlocProvider<ResultBloc>(bloc: _resultBloc),
        BlocProvider<FolderBloc>(bloc: _folderBloc),
        BlocProvider<PreferenceBloc>(bloc: _preferenceBloc),
        BlocProvider<ThemeBloc>(bloc: _themeBloc),
      ],
      child: BlocBuilder<ThemeData, ThemeData>(
        bloc: _themeBloc,
        builder: (context, snapshot) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            theme: snapshot,
            darkTheme: AppThemes.defaultTheme,
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
  }

  @override
  void dispose() {
    _historyBloc.dispose();
    _resultBloc.dispose();
    _folderBloc.dispose();
    _preferenceBloc.dispose();
    super.dispose();
  }
}
