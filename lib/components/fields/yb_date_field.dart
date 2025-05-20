import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YBDateField extends StatefulWidget {
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
  final ValueChanged<DateTime>? onDateSelected;

  const YBDateField({
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
    this.onDateSelected,
  }) : super(key: key);

  @override
  _YBDateFieldState createState() => _YBDateFieldState();
}

class _YBDateFieldState extends State<YBDateField> {
  TextEditingController get controller => widget.controller;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = widget.sizeScreen.width;
    final Color _borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final Color? textColor = widget.textColor ?? Theme.of(context).primaryColor;
    final Color? cursorColor = widget.cursorColor ?? Theme.of(context).primaryColor;
    final TextInputType keyboardType = widget.textType ?? TextInputType.datetime;
    final TextStyle hintStyle = TextStyle(color: widget.hintColor ?? Colors.grey[500]);
    final Color? iconColor = widget.iconColor ?? Colors.grey[500];

    return Container(
      height: widthScreen * 0.14,
      margin: EdgeInsets.symmetric(
        horizontal: widthScreen * 0.03,
        vertical: widthScreen * 0.03,
      ),
      child: TextFormField(
        controller: controller,
        autofocus: false,
        style: TextStyle(color: textColor),
        enableInteractiveSelection: true,
        cursorColor: cursorColor,
        keyboardType: keyboardType,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _borderColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          filled: true,
          hintStyle: hintStyle,
          hintText: widget.hint,
          fillColor: widget.fillColor ?? Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: iconColor, size: widthScreen * 0.06)
              : null,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_month),
            color: iconColor,
            onPressed: () => _selectDate(context),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: widthScreen * 0.02),
        ),
      ),
    );
  }
}
