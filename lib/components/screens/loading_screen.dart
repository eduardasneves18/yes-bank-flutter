import 'package:yes_bank/ui/platform_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends PlatformComponents {
  final String message;
  final bool show;

  LoadingScreen({this.show = false, this.message = 'Carregando...'});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return Visibility(
      visible: this.show,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: CupertinoActivityIndicator(
            animating: true,
            radius: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Visibility(
      visible: this.show,
      child: Center(
        child: Material(
          child: Container(
              width: size.width * 0.85,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                    backgroundColor: Colors.grey,
                  ),
                  Visibility(
                    visible: this.message.length > 0,
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontFamily: 'open-sans'),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
