import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class YBMaskTextField extends StatefulWidget {
  final Size? sizeScreen;
  final IconData? icon;
  final Color? iconColor;
  final String? hint;
  final Color? hintColor;
  final bool? security;
  final Color? fillColor;
  final TextInputType? textType;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;
  final TextEditingController? controller;
  final String? mask;

  const YBMaskTextField({
    Key? key,
    this.sizeScreen,
    this.icon,
    this.hint,
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
    this.controller,
    this.mask,
  }) : super(key: key);

  @override
  _YBMaskTextFieldState createState() => _YBMaskTextFieldState();
}

class _YBMaskTextFieldState extends State<YBMaskTextField> {
  bool showSecurityPassword = true;

  Widget build(BuildContext context) {
    final _widthScreen = widget.sizeScreen?.width;
    final Color _borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final Color? _textColor = widget.textColor != null ? widget.textColor : Theme.of(context).primaryColor;
    final Color? _cursorColor = widget.cursorColor != null ? widget.cursorColor : Theme.of(context).primaryColor;

    final TextInputType? _keyboardType = widget.textType != null ? widget.textType : TextInputType.text;

    final TextStyle _hintStyle = new TextStyle(color: widget.hintColor != null ? widget.iconColor : Colors.grey[500]);

    final Color? _iconColor = widget.iconColor != null ? widget.iconColor : Colors.grey[500];

    return Container(
      height: _widthScreen! * 0.14,
      margin: new EdgeInsets.symmetric(
        horizontal: _widthScreen * 0.03,
        vertical: _widthScreen * 0.02,
      ),
      child: new TextFormField(
        controller: widget.controller,
        autofocus: false,
        style: TextStyle(color: _textColor),
        enableInteractiveSelection: true,
        cursorColor: _cursorColor,
        keyboardType: _keyboardType,
        decoration: new InputDecoration(
            enabledBorder: new OutlineInputBorder(
                borderSide: new BorderSide(color: _borderColor, width: 0.5),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                )),
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            filled: true,
            hintStyle: _hintStyle,
            hintText: widget.hint,
            fillColor:
            widget.fillColor != null ? widget.fillColor : Colors.white,
            prefixIcon: Icon(
              widget.icon,
              color: _iconColor,
              size: _widthScreen * 0.06,
            ),
            suffixIcon: widget.security != null
                ? IconButton(
                color: widget.iconColor,
                icon: Icon(getIconSecury()),
                onPressed: () {
                  setState(() {
                    showSecurityPassword = !showSecurityPassword;
                  });
                })
                : null,
            contentPadding:
            new EdgeInsets.symmetric(horizontal: _widthScreen * 0.02)),
        obscureText: widget.security != null && showSecurityPassword,
      ),
    );
  }

  IconData getIconSecury() {
    if (widget.security != null && showSecurityPassword) {
      return Icons.visibility;
    } else {
      return Icons.visibility_off;
    }
  }
}
