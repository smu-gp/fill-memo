import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sp_client/model/local_auth.dart';
import 'package:sp_client/model/web_auth.dart';
import 'package:sp_client/screen/init_screen.dart';
import 'package:sp_client/screen/local_auth_screen.dart';
import 'package:sp_client/screen/web/intro_screen.dart';
import 'package:uuid/uuid.dart';

import 'bloc/blocs.dart';
import 'repository/repositories.dart';
import 'screen/main_screen.dart';
import 'util/utils.dart';

class App extends StatefulWidget {
  final AppConfig config;
  final PreferenceRepository preferenceRepository;

  App({
    Key key,
    @required this.config,
    @required this.preferenceRepository,
  })  : assert(config != null),
        assert(preferenceRepository != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  UserRepository _userRepository;
  MemoRepository _memoRepository;
  FolderRepository _folderRepository;

  bool _useFingerprint;
  String _userId;
  ThemeData _initTheme;

  ThemeBloc _themeBloc;
  AuthBloc _authBloc;
  MemoBloc _memoBloc;
  FolderBloc _folderBloc;

  @override
  void initState() {
    super.initState();
    _initRepository();
    _fetchSettings();
    _initBloc();
  }

  @override
  Widget build(BuildContext context) {
    var providers = <SingleChildCloneableWidget>[
      Provider<AppConfig>.value(value: widget.config),
      if (AppConfig.runOnWeb)
        ChangeNotifierProvider<WebAuthenticate>(
          builder: (context) => WebAuthenticate(),
        ),
      if (widget.config.useFingerprint)
        ChangeNotifierProvider<LocalAuthenticate>(
          builder: (context) => LocalAuthenticate(!_useFingerprint),
        ),
    ];

    var blocProviders = <BlocProvider>[
      BlocProvider<ThemeBloc>.value(value: _themeBloc),
      BlocProvider<AuthBloc>.value(value: _authBloc),
      BlocProvider<MemoBloc>.value(value: _memoBloc),
      BlocProvider<FolderBloc>.value(value: _folderBloc),
    ];

    Widget main = BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          _memoBloc.dispatch(UpdateMemoUser(authState.uid));
          _folderBloc.dispatch(UpdateFolderUser(authState.uid));
          return MainScreen();
        } else {
          return BlocProvider(
            builder: (context) => LoginBloc(userRepository: _userRepository),
            child: InitScreen(userId: _userId),
          );
        }
      },
    );

    var home = main;

    if (AppConfig.runOnWeb) {
      home = Consumer<WebAuthenticate>(
        builder: (context, authenticate, _) {
          if (authenticate.value) {
            return main;
          } else {
            return WebIntroScreen();
          }
        },
      );
    }

    if (widget.config.useFingerprint) {
      home = Consumer<LocalAuthenticate>(
        builder: (context, authenticate, _) {
          if (authenticate.authenticated) {
            return main;
          } else {
            return LocalAuthScreen();
          }
        },
      );
    }

    return MultiProvider(
      providers: providers,
      child: MultiBlocProvider(
        providers: blocProviders,
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
                home: home,
              );
            },
          ),
        ),
      ),
    );
  }

  void _initRepository() {
    _userRepository = FirebaseUserRepository();
    _memoRepository = FirebaseMemoRepository();
    _folderRepository = FirebaseFolderRepository();
  }

  void _fetchSettings() {
    var darkMode =
        widget.preferenceRepository.getBool(AppPreferences.keyDarkMode);

    _initTheme =
        (darkMode ?? false) ? AppThemes.darkTheme : AppThemes.lightTheme;

    if (!AppConfig.runOnWeb) {
      _userId = widget.preferenceRepository.getString(
        AppPreferences.keyUserId,
      );

      if (_userId == null) {
        _userId = Uuid().v4();
        widget.preferenceRepository
            .setString(AppPreferences.keyUserId, _userId);
      }

      _useFingerprint = widget.preferenceRepository
              .getBool(AppPreferences.keyUseFingerprint) ??
          false;
    }
  }

  void _initBloc() {
    _themeBloc = ThemeBloc(_initTheme);
    _authBloc = AuthBloc(userRepository: _userRepository);
    _memoBloc = MemoBloc(memoRepository: _memoRepository);
    _folderBloc = FolderBloc(folderRepository: _folderRepository);

    if (!AppConfig.runOnWeb) {
      _authBloc.dispatch(AppStarted(_userId));
    }
  }
}
