import 'package:yes_bank/enums/device_screen_type.dart';
import 'package:flutter/cupertino.dart';

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  var orientation = mediaQuery.orientation;

  double deviceWidth = 0;

  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQuery.size.height;
  } else {
    deviceWidth = mediaQuery.size.width;
  }

  if (deviceWidth > 600) {
    return DeviceScreenType.Tablet;
  } else if (deviceWidth < 350) {
    return DeviceScreenType.SmallTMobile;
  }

  return DeviceScreenType.Mobile;
}

double getPixelByType(MediaQueryData mediaQuery, double pixel) {
  var orientation = mediaQuery.orientation;

  double deviceWidth = 0;

  if (orientation == Orientation.landscape) {
    deviceWidth = mediaQuery.size.height;
  } else {
    deviceWidth = mediaQuery.size.width;
  }

  if (deviceWidth > 600) {
    return pixel * 1.3;
  } else if (deviceWidth < 350) {
    return pixel * 0.8;
  }

  return pixel;
}
