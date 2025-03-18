import 'package:yes_bank/ui/sizing_information.dart';
import 'package:yes_bank/utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation)? builder;

  const ResponsiveWidget({Key? key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(builder: (context, boxConstraints) {
      var sizingInformation = SizingInformation(
        orientation: mediaQuery.orientation,
        deviceScreenType: getDeviceType(mediaQuery),
        screenSize: mediaQuery.size,
        localWidgetSize: Size(boxConstraints.maxWidth, boxConstraints.maxHeight),
      );

      if (builder != null) {
        return builder!(context, sizingInformation);
      }
      return Container();
    });
  }
}
