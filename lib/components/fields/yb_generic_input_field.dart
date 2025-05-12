import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class YBGenericInputField extends StatefulWidget {
  final String hint;
  final Size? sizeScreen;
  final IconData? icon;
  final Color? iconColor;
  final Color? hintColor;
  final Color? fillColor;
  final TextInputType? textType;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;
  final bool? security;
  final Color? menuBackgroundColor;
  final Color? fieldBackgroundColor;

  final TextEditingController controller;

  const YBGenericInputField({
    Key? key,
    required this.hint,
    this.sizeScreen,
    this.icon,
    this.iconColor,
    this.hintColor,
    this.fillColor,
    this.textType,
    this.cursorColor,
    this.borderColor,
    this.textColor,
    this.labelText,
    this.labelColor,
    this.security,
    this.fieldBackgroundColor,
    this.menuBackgroundColor,
    required this.controller,
  }) : super(key: key);

  @override
  State<YBGenericInputField> createState();
}

abstract class YBGenericInputFieldState<T extends YBGenericInputField> extends State<T> {
  TextEditingController get controller => widget.controller;

  Color? get borderColor => widget.borderColor;
  Color? get textColor => widget.textColor;
  Color? get cursorColor => widget.cursorColor;

  TextInputType get textType => widget.textType ?? TextInputType.text;
  bool get security => widget.security ?? false;
}
