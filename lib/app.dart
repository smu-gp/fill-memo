import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/screen/main_screen.dart';
import 'package:sp_client/util/utils.dart';

class App extends StatefulWidget {
  final HistoryRepository historyRepository;
  final ResultRepository resultRepository;
  final FolderRepository folderRepository;
  final SharedPreferences sharedPreferences;

  App({
    Key key,
    @required this.historyRepository,
    @required this.resultRepository,
    @required this.folderRepository,
    @required this.sharedPreferences,
  })  : assert(historyRepository != null),
        assert(resultRepository != null),
        assert(folderRepository != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  FolderBloc _folderBloc;
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc(historyRepository: widget.historyRepository);
    _resultBloc = ResultBloc(resultRepository: widget.resultRepository);
    _folderBloc = FolderBloc(folderRepository: widget.folderRepository);
    _preferenceBloc = PreferenceBloc(
      sharedPreferences: widget.sharedPreferences,
      usagePreferences: AppPreferences.preferences,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<HistoryBloc>(bloc: _historyBloc),
        BlocProvider<ResultBloc>(bloc: _resultBloc),
        BlocProvider<FolderBloc>(bloc: _folderBloc),
        BlocProvider<PreferenceBloc>(bloc: _preferenceBloc),
      ],
      child: BlocBuilder<PreferenceEvent, PreferenceState>(
        bloc: _preferenceBloc,
        builder: (context, prefState) {
          var isLightTheme =
              prefState.preferences.get(AppPreferences.keyLightTheme).value;
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context).appName,
            theme:
                (!isLightTheme ? AppThemes.defaultTheme : AppThemes.lightTheme),
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
