import 'dart:math';

import 'package:flutter/widgets.dart';

enum DisplaySize { normal, medium, large, xlarge }

enum CompareOption { width, height, both }

class Dimensions {
  // Common
  static final double iconSize = 48.0;

  static final double keyline = 16.0;
  static final double keylineLarge = 24.0;
  static final double keylineXLarge = 48.0;
  static final double keylineXXLarge = 96.0;
  static final double keylineSmall = 8.0;
  static final double keylineMini = 4.0;

  static double contentHorizontalMargin(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: keyline,
      large: keylineXXLarge,
      option: CompareOption.width,
    );
  }

  // Dialog
  static final double dialogSmallWidth = 280.0;
  static final double dialogLargeWidth = 560.0;
  static final double dialogListHeight = listOneLineHeight * 6;

  static double dialogWidth(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: dialogSmallWidth,
      large: dialogLargeWidth,
    );
  }

  // List
  static final double listOneLineHeight = 56.0;
  static final double listTwoLineHeight = 72.0;
  static final double listHandWritingHeight = 192.0;
  static final double preferenceLargeMargin = 56.0;

  static double listHorizontalMargin(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: keylineSmall,
      large: keyline,
    );
  }

  static double preferenceHorizontalMargin(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: 0,
      large: preferenceLargeMargin,
    );
  }

  // Grid
  static int gridCrossAxisCount(BuildContext context) {
    var displaySize = getDisplaySize(context, CompareOption.width);
    if (displaySize.index >= DisplaySize.large.index) {
      return 4;
    } else if (displaySize == DisplaySize.medium) {
      return 3;
    } else {
      return 2;
    }
  }

  // Custom
  static double imageNormalWidth = 360.0;
  static double imageNormalHeight = 240.0;
  static double imageLargeHeight = 360.0;

  static double codeTextFieldNormalWidth = 280.0;
  static double codeTextFieldLargeWidth = codeTextFieldNormalWidth * 1.2;
  static double codeTextFieldXLargeWidth = codeTextFieldLargeWidth * 1.2;

  static double introCardNormalWidth = 360.0;
  static double introCardLargeWidth = introCardNormalWidth * 1.2;
  static double introCardXLargeWidth = introCardLargeWidth * 1.2;

  static double codeTextFieldWidth(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: codeTextFieldNormalWidth,
      large: codeTextFieldLargeWidth,
      xlarge: codeTextFieldXLargeWidth,
    );
  }

  static double introCardWidth(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: introCardNormalWidth,
      large: introCardLargeWidth,
      xlarge: introCardXLargeWidth,
    );
  }

  static double imageHeight(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: imageNormalHeight,
      large: imageLargeHeight,
    );
  }

  static double imageHorizontalMargin(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: 0,
      large: keylineXXLarge,
      option: CompareOption.width,
    );
  }

  // Functions
  static double responsiveDimension({
    @required BuildContext context,
    @required double normal,
    double medium = -1,
    @required double large,
    double xlarge = -1,
    CompareOption option = CompareOption.both,
  }) {
    var displaySize = getDisplaySize(context, option);
    if (displaySize.index >= DisplaySize.xlarge.index) {
      if (xlarge != -1) {
        return xlarge;
      }
    }
    if (displaySize.index >= DisplaySize.large.index) {
      return large;
    }
    if (displaySize.index >= DisplaySize.medium.index) {
      if (medium != -1) {
        return medium;
      }
    }
    return normal;
  }

  static DisplaySize getDisplaySize(
    BuildContext context,
    CompareOption option,
  ) {
    assert(context != null);
    var size = MediaQuery.of(context).size;
    var compareValue;
    if (option == CompareOption.width) {
      compareValue = size.width;
    } else if (option == CompareOption.height) {
      compareValue = size.height;
    } else {
      compareValue = min(size.width, size.height);
    }

    if (compareValue > 1280) {
      return DisplaySize.xlarge;
    } else if (compareValue > 600) {
      return DisplaySize.large;
    } else if (compareValue > 480) {
      return DisplaySize.medium;
    }
    return DisplaySize.normal;
  }
}
