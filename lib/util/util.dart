import 'package:intl/intl.dart';

class Util {
  static String formatDate(int milliseconds, pattern) =>
      DateFormat(pattern, 'ko_KR')
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}
