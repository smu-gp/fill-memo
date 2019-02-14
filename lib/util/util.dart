import 'package:intl/intl.dart';

class Util {
  static String formatDate(int milliseconds) => DateFormat.MMMMEEEEd('ko_KR')
      .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}
