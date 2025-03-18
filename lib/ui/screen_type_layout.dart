import 'package:yes_bank/enums/device_screen_type.dart';
import 'package:yes_bank/ui/responsive_widget.dart';
import 'package:flutter/material.dart';

class ScreenTypeLayout extends StatelessWidget {
  final Widget? mobile;
  final Widget? smallMobile;
  final Widget? tablet;

  const ScreenTypeLayout({
    Key? key,
    this.mobile,
    this.smallMobile,
    this.tablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (context, sizingInformation) {
      if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
        if (tablet != null) {
          return getDevice(tablet);
        }
      }

      if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
        if (mobile != null) {
          return getDevice(mobile);
        }
      }
      return getDevice(smallMobile);
    });
  }

  Widget getDevice(Widget? orientation) {
    return orientation ?? Container();
  }
}

