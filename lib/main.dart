import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sp_client/localizations.dart';
import 'package:sp_client/screen/main.dart';
import 'package:sp_client/screen/splash.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).get('title'),
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('en', ''), const Locale('ko', '')],
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{'/main': (context) => MainScreen()},
    );
  }
}
