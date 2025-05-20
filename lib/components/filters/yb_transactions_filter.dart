import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yes_bank/components/fields/yb_date_field.dart';
import 'package:yes_bank/components/fields/yb_number_field.dart';
import 'package:yes_bank/components/fields/yb_text_field.dart';
import 'package:yes_bank/components/fields/yb_dropdown_field.dart';
import '../../services/firebase/firebase.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';

class YbTransactionsFilter extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onFilterApplied;

  YbTransactionsFilter({required this.onFilterApplied});

  @override
  _YbTransactionsFilterState createState() => _YbTransactionsFilterState();
}

class _YbTransactionsFilterState extends State<YbTransactionsFilter> {
  String? _selectedTipoTransacao;
  String? _selectedDestinatario;
  double? _selectedValor;
  DateTime? _selectedData;
  BuildContext? _context;

  final _destinatarioController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  void _applyFilter() {
    TransactionsFirebaseService firebaseService = TransactionsFirebaseService();

    String? destinatario = _selectedDestinatario?.isEmpty ?? true ? null : _selectedDestinatario;
    double? valor = _selectedValor == null || _selectedValor == 0 ? null : _selectedValor;
    String? data = _selectedData == null ? null : DateFormat('dd/MM/yyyy').format(_selectedData!);

    firebaseService.getTransactionsFiltered(
      tipoTransacao: _selectedTipoTransacao,
      destinatario: destinatario,
      valor: valor,
      data: data,
    ).then((transactions) {
      widget.onFilterApplied(transactions);
      Navigator.pop(_context!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _context = context;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text("Filtro de transações", style: TextStyle(fontSize: 20))),
              SizedBox(height: 8),
              YBTextField(
                sizeScreen: size,
                controller: _destinatarioController,
                hint: 'Digite o destinatário',
                labelText: 'Destinatário',
                borderColor: Colors.black,
                textColor: Colors.black,
                fillColor: Colors.white,
                labelColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    _selectedDestinatario = value;
                  });
                },
              ),
              YBDropdownField(
                onChanged: (value) {
                  setState(() {
                    _selectedTipoTransacao = value;
                  });
                },
                hint: 'Tipo transação',
                borderColor: Colors.black,
                textColor: Colors.black,
                fillColor: Colors.transparent,
                labelColor: Colors.black,
                labelText: 'Tipo transação',
                sizeScreen: size,
                iconColor: Colors.black,
              ),

              // Valor
              YBNumberField(
                sizeScreen: size,
                controller: _valorController,
                hint: 'Digite o valor',
                labelText: 'Valor',
                borderColor: Colors.black,
                textColor: Colors.black,
                fillColor: Colors.white,
                labelColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    _selectedValor =
                    value.isEmpty ? null : double.tryParse(value);
                  });
                },
              ),

              // Data
              YBDateField(
                sizeScreen: size,
                controller: _dataController,
                hint: 'Selecione a data',
                labelText: 'Data',
                borderColor: Colors.black,
                textColor: Colors.black,
                fillColor: Colors.white,
                labelColor: Colors.black,
              ),

              SizedBox(height: 16),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004D61),
                    foregroundColor: Colors.grey[100],
                  ),
                  onPressed: _applyFilter,
                  child: Text("Aplicar Filtro"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
