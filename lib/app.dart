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
  final UserRepository userRepository;
  final MemoRepository memoRepository;
  final FolderRepository folderRepository;

  App({
    Key key,
    @required this.preferenceRepository,
    @required this.userRepository,
    @required this.memoRepository,
    @required this.folderRepository,
  })  : assert(preferenceRepository != null),
        assert(userRepository != null),
        assert(memoRepository != null),
        assert(folderRepository != null),
        super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    var preferenceBloc = PreferenceBloc(
      repository: widget.preferenceRepository,
      usagePreferences: AppPreferences.preferences,
    );

    var userId = preferenceBloc.getPreference<String>(AppPreferences.keyUserId);
    if (userId.value == null) {
      userId.value = Uuid().v4();
      preferenceBloc.dispatch(UpdatePreference(userId));
    }

    var darkMode =
        preferenceBloc.getPreference<bool>(AppPreferences.keyDarkMode).value;
    var initTheme = darkMode ? AppThemes.darkTheme : AppThemes.lightTheme;
    var themeBloc = ThemeBloc(initTheme);

    var authBloc = AuthBloc(userRepository: widget.userRepository)
      ..dispatch(AppStarted());

    var memoBloc = MemoBloc(widget.memoRepository);
    var folderBloc = FolderBloc(widget.folderRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<PreferenceBloc>.value(
          value: preferenceBloc,
        ),
        BlocProvider<ThemeBloc>.value(
          value: themeBloc,
        ),
        BlocProvider<AuthBloc>.value(
          value: authBloc,
        ),
        BlocProvider<MemoBloc>.value(
          value: memoBloc,
        ),
        BlocProvider<FolderBloc>.value(
          value: folderBloc,
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is Authenticated) {
            memoBloc.dispatch(ReadMemo());
            folderBloc.dispatch(ReadFolder());
          }
        },
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
                    return MainScreen();
                  } else {
                    var loginBloc =
                        LoginBloc(userRepository: widget.userRepository)
                          ..dispatch(LoginSubmitted(userId.value));
                    return BlocListener<LoginBloc, LoginState>(
                      bloc: loginBloc,
                      listener: (context, state) {
                        if (state.isSuccess) {
                          authBloc.dispatch(LoggedIn());
                        } else if (state.isFailure) {
                          // Retry login
                          loginBloc.dispatch(LoginSubmitted(userId.value));
                        }
                      },
                      child: _buildUninitialized(context),
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

  Widget _buildUninitialized(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 24.0),
            Text(AppLocalizations.of(context).labelAppInitialize),
          ],
        ),
      ),
    );
  }
}
