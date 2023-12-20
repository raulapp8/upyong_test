import 'package:flutter/cupertino.dart';

/// ----------------------------------------------------------
///
///
///
/// 調整字的大小，
/// 在主頁進來時設定
///
/// StartPage
///   build
/// HYSizeFit.initialize(context);
///
///
///
/// -----------------------------------------------------------
class HYSizeFit {
  static MediaQueryData? _mediaQueryData;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double rpx = 0;
  static double px = 0;

  static void initialize(BuildContext context, {double standardWidth = 750}) {
    _mediaQueryData = MediaQuery.of(context);
    if (null == _mediaQueryData) return;
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    rpx = screenWidth / standardWidth;
    px = screenWidth / standardWidth * 2;
  }

  // 按照像素来设置
  static double setPx(double size) {
    return HYSizeFit.rpx * size * 2;
  }

  // 按照rxp来设置
  static double setRpx(double size) {
    return HYSizeFit.rpx * size;
  }
}

extension IntFit on int {
  double get px {
    return HYSizeFit.setPx(toDouble());
  }

  double get rpx {
    return HYSizeFit.setRpx(toDouble());
  }

  double get piw {
    return toDouble().piw ;
  }
  double get pih {
    return toDouble().pih ;
  }


}

extension DoubleFit on double
{
  String Fixed(int count )
  {
    return toStringAsFixed(count) ;
  }

  // pi
  double get piw {
    return this * HYSizeFit.screenWidth ;
  }
  double get pih {
    return this * HYSizeFit.screenHeight ;
  }
}