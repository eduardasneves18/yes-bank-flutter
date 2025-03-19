import 'package:flutter/material.dart';

class YBDropdownField extends StatefulWidget {
  final Function(String?) onChanged;
  final Size? sizeScreen;
  final String hint;
  final Icon? icon;
  final Color? iconColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? fieldBackgroundColor;
  final Color? menuBackgroundColor;
  final TextStyle? textType;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;

  YBDropdownField({
    required this.onChanged,
    required this.hint,
    this.sizeScreen,
    this.icon,
    this.iconColor,
    this.hintColor,
    this.fillColor,
    this.fieldBackgroundColor,
    this.menuBackgroundColor,
    this.textType,
    this.borderColor,
    this.textColor,
    this.labelText,
    this.labelColor,
  });

  @override
  _YBDropDownFieldState createState() => _YBDropDownFieldState();
}

class _YBDropDownFieldState extends State<YBDropdownField> {
  String? _selectedTipoTransacao;

  final List<String> tiposTransacao = ['Transferência', 'Pagamento', 'Recebimento'];

  @override
  Widget build(BuildContext context) {
    final double widthScreen = widget.sizeScreen?.width ?? MediaQuery.of(context).size.width; // Set screen width
    final Color borderColor = widget.borderColor ?? Colors.black;
    final Color fieldBackgroundColor = widget.fieldBackgroundColor ?? Colors.white;
    final Color menuBackgroundColor = widget.menuBackgroundColor ?? Colors.white;

    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.labelText != null
              ? Text(
            widget.labelText!,
            style: TextStyle(
              fontSize: 16,
              color: widget.labelColor ?? Colors.black,
            ),
          )
              : SizedBox.shrink(),
          SizedBox(height: 8),
          // Dropdown Button Container
          Container(
            width: widthScreen * 0.9,
            height: widthScreen * 0.14,
            decoration: BoxDecoration(
              color: fieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor,
                width: 1.5,
              ),
            ),
            child: DropdownButton<String>(
              value: _selectedTipoTransacao,
              hint: Text(
                widget.hint,
                style: TextStyle(
                  color: widget.hintColor ?? Colors.grey,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedTipoTransacao = value;
                });
                widget.onChanged(value);
              },
              items: tiposTransacao.map((tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(
                    tipo,
                    style: widget.textType ??
                        TextStyle(color: widget.textColor ?? Colors.black),
                  ),
                );
              }).toList(),
              icon: widget.icon ?? Icon(Icons.arrow_drop_down),
              iconEnabledColor: widget.iconColor ?? Colors.black,
              dropdownColor: menuBackgroundColor,
              underline: SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
