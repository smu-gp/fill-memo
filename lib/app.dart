import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/bloc/result_bloc_provider.dart';
import 'package:sp_client/repository/base_repository.dart';
import 'package:sp_client/screen/main_screen.dart';
import 'package:sp_client/util/color.dart';
import 'package:sp_client/util/localization.dart';

class App extends StatelessWidget {
  final BaseHistoryRepository historyRepository;
  final BaseResultRepository resultRepository;

  App({this.historyRepository, this.resultRepository});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: AppColors.primaryColorDark,
      ),
    );

    return HistoryBlocProvider(
      bloc: HistoryBloc(historyRepository),
      child: ResultBlocProvider(
        bloc: ResultBloc(resultRepository),
        child: MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appName,
          theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryColor,
            primaryColorLight: AppColors.primaryColorLight,
            primaryColorDark: AppColors.primaryColorDark,
            accentColor: AppColors.accentColor,
            backgroundColor: AppColors.backgroundColor,
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
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
