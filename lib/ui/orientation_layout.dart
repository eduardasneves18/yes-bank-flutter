import 'package:flutter/cupertino.dart';

class OrientationLayout extends StatelessWidget {
  final Widget? landscape;
  final Widget? portrait;

    const OrientationLayout({
    Key? key,
    this.landscape,
    this.portrait,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return getOrientation(landscape);
    }

    return getOrientation(portrait);
  }
}

Widget getOrientation(Widget? orientation) {
    return orientation ?? Container();
}
