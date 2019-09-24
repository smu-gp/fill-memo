import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_browser.dart';

Future<String> initializeLocale(Locale locale) async {
  var localeName = await findSystemLocale();
  await initializeDateFormatting(localeName);
  return localeName;
}
