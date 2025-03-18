import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yes_bank/components/fields/yb_dropdown_field.dart';
import '../../database/firebase_database.dart';

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

  final _destinatarioController = TextEditingController();
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  void _applyFilter() {
    FirebaseService firebaseService = FirebaseService();

    String? destinatario = _selectedDestinatario?.isEmpty ?? true ? null : _selectedDestinatario;
    double? valor = _selectedValor == null || _selectedValor == 0 ? null : _selectedValor;
    String? data = _selectedData == null ? null : DateFormat('dd/MM/yyy').format(_selectedData!);

    firebaseService.getTransactionsFiltered(
      tipoTransacao: _selectedTipoTransacao,
      destinatario: destinatario,
      valor: valor,
      data: data,
    ).then((transactions) {
      widget.onFilterApplied(transactions);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Center(child: Text("Filtro de transações", style: TextStyle(fontSize: 20))),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _destinatarioController,
                  decoration: InputDecoration(labelText: 'Destinatário'),
                  onChanged: (value) {
                    setState(() {
                      _selectedDestinatario = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              YBDropdownField(
                onChanged: (value) {
                  setState(() {
                    _selectedTipoTransacao = value;
                  })
                  ;
                },
                hint: 'Data',
                borderColor: Colors.black,
                textColor: Colors.black,
                fillColor: Colors.transparent,
                labelColor: Colors.white,
                labelText: 'Data',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Valor'),
                  onChanged: (value) {
                    setState(() {
                      _selectedValor = value.isEmpty ? null : double.tryParse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _dataController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Data'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedData ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedData) {
                      setState(() {
                        _selectedData = pickedDate;
                        _dataController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                ),
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
