import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YBNumberField extends StatefulWidget {
  final Size sizeScreen;
  final IconData? icon;
  final Color? iconColor;
  final String hint;
  final Color? hintColor;
  final Color? fillColor;
  final TextInputType? textType;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const YBNumberField({
    Key? key,
    required this.sizeScreen,
    this.icon,
    required this.hint,
    this.iconColor,
    this.hintColor,
    this.fillColor,
    this.textType,
    this.cursorColor,
    this.borderColor,
    this.textColor,
    this.labelText,
    this.labelColor,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  _YBNumberFieldState createState() => _YBNumberFieldState();
}

class _YBNumberFieldState extends State<YBNumberField> {
  TextEditingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final _widthScreen = widget.sizeScreen.width;
    final Color _borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final Color? _textColor = widget.textColor ?? Theme.of(context).primaryColor;
    final Color? _cursorColor = widget.cursorColor ?? Theme.of(context).primaryColor;

    final TextInputType _keyboardType = widget.textType ?? TextInputType.number;
    final TextStyle _hintStyle = TextStyle(color: widget.hintColor ?? Colors.grey[500]);
    final Color? _iconColor = widget.iconColor ?? Colors.grey[500];

    return Container(
      height: _widthScreen * 0.14,
      margin: EdgeInsets.symmetric(
        horizontal: _widthScreen * 0.03,
        vertical: _widthScreen * 0.03,
      ),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        style: TextStyle(color: _textColor),
        enableInteractiveSelection: true,
        cursorColor: _cursorColor,
        keyboardType: _keyboardType,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _borderColor,
              width: (1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          filled: true,
          hintStyle: _hintStyle,
          hintText: widget.hint,
          fillColor: widget.fillColor ?? Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: _iconColor, size: _widthScreen * 0.06)
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: _widthScreen * 0.02),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: widget.onChanged,
      ),
    );
  }
}
