import 'package:yes_bank/ui/platform_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FailureScreen extends PlatformComponents {
  final String message;
  final String title;

  FailureScreen({this.title = 'Erro', required this.message});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(this.title),
      content: Container(
        padding: const EdgeInsets.all(10.0),
        child: Text(message),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            'CONFIRMAR',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        this.title,
        style: TextStyle(color: Colors.black),
      ),
      content: Container(
        padding: const EdgeInsets.all(1.0),
        child: Text(message),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('CONFIRMAR'),
            onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}
