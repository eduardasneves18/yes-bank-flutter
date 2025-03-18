
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/platform_components.dart';

class ScheduleConfirmationScreen extends PlatformComponents {
  final String message;
  final String title;

  ScheduleConfirmationScreen({
    this.title = 'Confirmação',
    required this.message,
  });

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Container(
        padding: const EdgeInsets.all(10.0),
        child: Text(message),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            'Confirmar',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          onPressed: () => {},
        ),
        CupertinoDialogAction(
          child: Text(
            'Cancelar',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          onPressed: () => {},
        ),
      ],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {

    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      content: Container(
        padding: const EdgeInsets.all(1.0),
        child: Text(message),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('Confirmar'),
            onPressed: () => {}),
        TextButton(
          child: Text('Cancelar'),
          onPressed: () => {},
        ),
      ],
    );
  }
}
