import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Util {
  static String formatDate(int milliseconds, pattern) =>
      DateFormat(pattern, 'ko_KR')
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
}
