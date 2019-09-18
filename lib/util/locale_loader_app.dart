import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String> initializeLocale(Locale locale) async {
  final String name =
      locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
  return Intl.canonicalizedLocale(name);
}
