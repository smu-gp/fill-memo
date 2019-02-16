import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/bloc/result_bloc_provider.dart';
import 'package:sp_client/repository/base_repository.dart';
import 'package:sp_client/screen/main_screen.dart';
import 'package:sp_client/util/localization.dart';

class App extends StatelessWidget {
  final BaseHistoryRepository historyRepository;
  final BaseResultRepository resultRepository;

  App({this.historyRepository, this.resultRepository});

  @override
  Widget build(BuildContext context) {
    return HistoryBlocProvider(
      bloc: HistoryBloc(historyRepository),
      child: ResultBlocProvider(
        bloc: ResultBloc(resultRepository),
        child: MaterialApp(
          onGenerateTitle: (context) =>
              AppLocalizations.of(context).get('app_name'),
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            backgroundColor: Colors.white,
            accentColor: Color(0xFFFF6F61),
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
