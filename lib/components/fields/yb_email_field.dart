import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YBEmailField extends StatefulWidget {
  final Size sizeScreen;
  final IconData? icon;
  final Color? iconColor;
  final String hint;
  final Color? hintColor;
  final bool? security;
  final Color? fillColor;
  final TextInputType? textType;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;
  final TextEditingController controller;

  const YBEmailField({
    Key? key,
    required this.sizeScreen,
    this.icon,
    required this.hint,
    this.security = false,
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
  }) : super(key: key);

  @override
  _YBEmailFieldState createState() => _YBEmailFieldState();
}

class _YBEmailFieldState extends State<YBEmailField> {
  bool showSecurityPassword = true;

  Widget build(BuildContext context) {
    final _widthScreen = widget.sizeScreen.width;
    final Color _borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final Color? _textColor = widget.textColor ?? Theme.of(context).primaryColor;
    final Color? _cursorColor = widget.cursorColor ?? Theme.of(context).primaryColor;

    final TextInputType _keyboardType = TextInputType.emailAddress;
    final TextStyle _hintStyle = TextStyle(color: widget.hintColor ?? Colors.grey[500]);
    final Color? _iconColor = widget.iconColor ?? Colors.grey[500];

    return Container(
      height: _widthScreen * 0.14,
      margin: EdgeInsets.symmetric(
        horizontal: _widthScreen * 0.03,
        vertical: _widthScreen * 0.03,
      ),
      child: TextFormField(
        controller: widget.controller,
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
            borderSide: BorderSide(
              color: _borderColor,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          filled: true,
          hintStyle: _hintStyle,
          hintText: widget.hint,
          fillColor: widget.fillColor ?? Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: _iconColor, size: _widthScreen * 0.06)
              : null,
          suffixIcon: widget.security != true
              ? null
              : IconButton(
              color: widget.iconColor,
              icon: Icon(getIconSecury()),
              onPressed: () {
                setState(() {
                  showSecurityPassword = !showSecurityPassword;
                });
              }),
          contentPadding: EdgeInsets.symmetric(horizontal: _widthScreen * 0.02),
        ),
        obscureText: widget.security != null && showSecurityPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira um email';
          }
          String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value)) {
            return 'Por favor, insira um email válido';
          }
          return null;
        },
      ),
    );
  }

  IconData getIconSecury() {
    return showSecurityPassword ? Icons.visibility : Icons.visibility_off;
  }
}
