import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Util {
  static String formatDate(int milliseconds, pattern) =>
      DateFormat(pattern, 'ko_KR')
          .format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

  static bool isTablet(BuildContext context) {
    assert(context != null);
    var size = MediaQuery.of(context).size;
    return min(size.width, size.height) > 600;
  }
}
