import 'package:flutter/material.dart';

class YBDropdownField extends StatefulWidget {
  final Function(String?) onChanged;
  final Size sizeScreen;
  final String hint;
  final IconData? icon;
  final Color? iconColor;
  final Color? hintColor;
  final Color? fillColor;
  final TextStyle? textType;
  final Color? borderColor;
  final Color? textColor;
  final String? labelText;
  final Color? labelColor;
  final String? initialValue;
  final Color? dropdownColor;

  const YBDropdownField({
    Key? key,
    required this.onChanged,
    required this.hint,
    required this.sizeScreen,
    this.icon,
    this.iconColor,
    this.hintColor,
    this.fillColor,
    this.textType,
    this.borderColor,
    this.textColor,
    this.labelText,
    this.labelColor,
    this.initialValue,
    this.dropdownColor,
  }) : super(key: key);

  @override
  _YBDropDownFieldState createState() => _YBDropDownFieldState();

}

class _YBDropDownFieldState extends State<YBDropdownField> {
  String? _selectedTipoTransacao;
  final List<String> tiposTransacao = ['Transferência', 'Pagamento', 'Recebimento'];

  @override
  void initState() {
    super.initState();
    _selectedTipoTransacao = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = widget.sizeScreen.width;
    final Color _borderColor = widget.borderColor ?? Theme.of(context).primaryColor;
    final Color? _textColor = widget.textColor ?? Theme.of(context).primaryColor;
    final Color? _hintColor = widget.hintColor ?? Colors.grey[500];
    final Color? _iconColor = widget.iconColor ?? Colors.grey[500];
    final Color? _fillColor = widget.fillColor ?? Colors.white;
    final Color _dropdownColor = widget.dropdownColor ?? Colors.white;

    return Container(
      height: widthScreen * 0.14,
      margin: EdgeInsets.symmetric(
        horizontal: widthScreen * 0.03,
        vertical: widthScreen * 0.03,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTipoTransacao,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.labelColor ?? Colors.black),
          filled: true,
          fillColor: _fillColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _borderColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _borderColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: _hintColor),
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: _iconColor, size: widthScreen * 0.06)
              : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: widthScreen * 0.02,
            vertical: widthScreen * 0.04,
          ),
        ),
        icon: Icon(Icons.arrow_drop_down, color: _iconColor),
        dropdownColor: _dropdownColor,
        style: widget.textType ?? TextStyle(color: _textColor),
        onChanged: (value) {
          setState(() {
            _selectedTipoTransacao = value;
          });
          widget.onChanged(value);
        },
        items: tiposTransacao.map((tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
      ),
    );
  }
}
