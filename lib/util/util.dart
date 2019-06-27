import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Util {
  static String formatDate(int timestamp) {
    var timestampDay = DateTime.fromMillisecondsSinceEpoch(timestamp).day;
    var currentDay = DateTime.now().day;

    return DateFormat(
            (timestampDay == currentDay) ? "a hh:mm" : "MMMMEEEEd", 'ko_KR')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static bool isTablet(BuildContext context) {
    assert(context != null);
    var size = MediaQuery.of(context).size;
    return min(size.width, size.height) > 600;
  }
}
