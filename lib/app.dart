import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/screen/main_screen.dart';
import 'package:sp_client/util/utils.dart';

class App extends StatefulWidget {
  final BaseHistoryRepository historyRepository;
  final BaseResultRepository resultRepository;
  final BaseFolderRepository folderRepository;

  App({
    Key key,
    @required this.historyRepository,
    @required this.resultRepository,
    @required this.folderRepository,
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

  @override
  void initState() {
    super.initState();
    _historyBloc = HistoryBloc(historyRepository: widget.historyRepository);
    _resultBloc = ResultBloc(resultRepository: widget.resultRepository);
    _folderBloc = FolderBloc(folderRepository: widget.folderRepository);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: AppColors.primaryColorDark,
      ),
    );

    return BlocProviderTree(
      blocProviders: [
        BlocProvider<HistoryBloc>(bloc: _historyBloc),
        BlocProvider<ResultBloc>(bloc: _resultBloc),
        BlocProvider<FolderBloc>(bloc: _folderBloc),
      ],
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primaryColor,
          primaryColorLight: AppColors.primaryColorLight,
          primaryColorDark: AppColors.primaryColorDark,
          accentColor: AppColors.accentColor,
          backgroundColor: AppColors.backgroundColor,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          dialogBackgroundColor: AppColors.backgroundColor,
          bottomAppBarColor: AppColors.primaryColorDark,
          // For BottomNavigationBar background color
          canvasColor: AppColors.primaryColorDark,
        ),
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
      ),
    );
  }

  @override
  void dispose() {
    _historyBloc.dispose();
    _resultBloc.dispose();
    _folderBloc.dispose();
    super.dispose();
  }
}
