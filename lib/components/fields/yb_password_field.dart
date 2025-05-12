import 'package:flutter/material.dart';
import 'yb_generic_input_field.dart';

class YBPasswordField extends YBGenericInputField {
  const YBPasswordField({
    Key? key,
    required String hint,
    required TextEditingController controller,
    required Size sizeScreen,
    IconData? icon,
    Color? iconColor,
    Color? hintColor,
    Color? fillColor,
    TextInputType? textType,
    Color? cursorColor,
    Color? borderColor,
    Color? textColor,
    String? labelText,
    Color? labelColor,
    bool? security = true,
    Color? menuBackgroundColor,
    Color? fieldBackgroundColor,
  }) : super(
    key: key,
    hint: hint,
    controller: controller,
    sizeScreen: sizeScreen,
    icon: icon,
    iconColor: iconColor,
    hintColor: hintColor,
    fillColor: fillColor,
    textType: textType,
    cursorColor: cursorColor,
    borderColor: borderColor,
    textColor: textColor,
    labelText: labelText,
    labelColor: labelColor,
    security: security,
    menuBackgroundColor: menuBackgroundColor,
    fieldBackgroundColor: fieldBackgroundColor,
  );

  @override
  State<YBPasswordField> createState() => _YBPasswordFieldState();
}

class _YBPasswordFieldState extends YBGenericInputFieldState<YBPasswordField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final width = widget.sizeScreen?.width ?? MediaQuery.of(context).size.width;

    return Container(
      height: width * 0.14,
      margin: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.03),
      child: TextFormField(
        controller: widget.controller,
        autofocus: false,
        obscureText: showPassword,
        cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
        style: TextStyle(color: widget.textColor ?? Theme.of(context).primaryColor),
        keyboardType: widget.textType,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo obrigatório';
          if (value.length < 6) return 'A senha deve ter no mínimo 6 caracteres';
          return null;
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor ?? Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          hintStyle: TextStyle(color: widget.hintColor ?? Colors.grey[500]),
          hintText: widget.hint,
          fillColor: widget.fillColor ?? Colors.white,
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: widget.iconColor ?? Colors.grey[500], size: width * 0.06)
              : null,
          suffixIcon: IconButton(
            icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => showPassword = !showPassword),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: width * 0.02),
        ),
      ),
    );
  }
}
