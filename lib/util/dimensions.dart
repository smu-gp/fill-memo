import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum DisplaySize {
  normal,
  /** Over 480px */
  medium,
  /** Over 600px */
  large,
  /** Over 1280px */
  xlarge,
  /** Over 1920px */
  xxlarge,
  /** Over 2560px */
  xxxlarge,
}

enum CompareOption { width, height, both }

class Dimensions {
  // Common
  static final double increment = 64.0;

  static final double iconSize = 48.0;

  static final double keyline = 16.0;
  static final double keylineLarge = 24.0;
  static final double keylineXLarge = 48.0;
  static final double keylineXXLarge = 96.0;
  static final double keylineSmall = 8.0;
  static final double keylineMini = 4.0;

  static double contentWidth(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: double.infinity,
      large: increment * 8,
      xlarge: increment * 12,
      xxxlarge: increment * 24,
      option: kIsWeb ? CompareOption.width : CompareOption.both,
    );
  }

  static double contentHorizontalMargin(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: keyline,
      large: 0,
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

  static double listWidth(BuildContext context) {
    return responsiveDimension(
      context: context,
      normal: double.infinity,
      large: double.infinity,
      xlarge: increment * 16,
      xxlarge: increment * 24,
      xxxlarge: increment * 32,
      option: kIsWeb ? CompareOption.width : CompareOption.both,
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
    print(displaySize);
    if (displaySize.index >= DisplaySize.xxlarge.index) {
      return 6;
    } else if (displaySize.index >= DisplaySize.large.index) {
      return 4;
    } else {
      return 2;
    }
  }

  // Custom
  static double imageNormalWidth = 360.0;
  static double imageNormalHeight = 240.0;
  static double imageLargeHeight = 360.0;
  static double imageXLargeHeight = 480.0;
  static double imageXXLargeHeight = 560.0;

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
      xlarge: imageXLargeHeight,
      xxlarge: imageXXLargeHeight,
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
    double xxlarge = -1,
    double xxxlarge = -1,
    CompareOption option = CompareOption.both,
  }) {
    var displaySize = getDisplaySize(context, option);
    if (displaySize.index >= DisplaySize.xxxlarge.index) {
      if (xxxlarge != -1) {
        return xxxlarge;
      }
    }
    if (displaySize.index >= DisplaySize.xxlarge.index) {
      if (xxlarge != -1) {
        return xxlarge;
      }
    }
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

    if (compareValue > 2560) {
      return DisplaySize.xxxlarge;
    } else if (compareValue > 1920) {
      return DisplaySize.xxlarge;
    } else if (compareValue > 1280) {
      return DisplaySize.xlarge;
    } else if (compareValue > 600) {
      return DisplaySize.large;
    } else if (compareValue > 480) {
      return DisplaySize.medium;
    }
    return DisplaySize.normal;
  }
}
