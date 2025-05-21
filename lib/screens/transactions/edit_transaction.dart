import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../components/dialogs/yb_dialog_message.dart';
import '../../components/fields/yb_date_field.dart';
import '../../components/fields/yb_number_field.dart';
import '../../components/fields/yb_text_field.dart';
import '../../components/fields/yb_dropdown_field.dart';
import '../../components/screens/yb_app_bar.dart';
import '../../services/firebase/firebase.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';
import 'list_transactions.dart';

class EditTransaction extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final List<Map<String, dynamic>> transactions;

  EditTransaction({required this.transaction, required this.transactions});

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final TextEditingController _destinatarioController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  BuildContext? _context;
  String? _selectedTipoTransacao;
  final TransactionsFirebaseService _firebaseService = TransactionsFirebaseService();

  @override
  void initState() {
    super.initState();
    _destinatarioController.text = widget.transaction['destinatario'] ?? '';
    _selectedTipoTransacao = widget.transaction['tipo_transacao'] ?? '';
    _valorController.text = widget.transaction['valor'].toString();
    _dataController.text = widget.transaction['data'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;
    _context = context;
    return ComponenteGeral(
      sizeScreen: sizeScreen,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    'Edição de transação',
                    style: TextStyle(
                      fontSize: sizeScreen.width * 0.05,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                YBTextField(
                  controller: _destinatarioController,
                  sizeScreen: sizeScreen,
                  hint: 'Destinatário',
                  labelText: 'Destinatário',
                  labelColor: Colors.white,
                  fillColor: Colors.transparent,
                  textColor: Colors.grey,
                  security: null,
                ),
                YBDropdownField(
                  value: _selectedTipoTransacao,
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoTransacao = value;
                    });
                  },
                  sizeScreen: sizeScreen,
                  hint: '---',
                  borderColor: Colors.black,
                  textColor: Colors.grey,
                  fillColor: Colors.transparent,
                  labelColor: Colors.white,
                  labelText: 'Tipo de transação',
                ),
                YBNumberField(
                  controller: _valorController,
                  sizeScreen: sizeScreen,
                  hint: 'Valor',
                  labelText: 'Valor',
                  labelColor: Colors.white,
                  fillColor: Colors.transparent,
                  textColor: Colors.grey,
                ),
                YBDateField(
                  controller: _dataController,
                  sizeScreen: sizeScreen,
                  hint: 'Data',
                  labelText: 'Data',
                  labelColor: Colors.white,
                  fillColor: Colors.transparent,
                  textColor: Colors.grey,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: sizeScreen.height * 0.03),
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: sizeScreen.width * 0.90,
                height: sizeScreen.width * 0.12,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF004D61),
                    foregroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                  ),
                  child: Text(
                    'Atualizar transação',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    String destinatarioTransacao = _destinatarioController.text.trim();
                    String tipoTransacao = _selectedTipoTransacao ?? '';
                    String valorTransacao = _valorController.text.trim();
                    String dataTransacao = _dataController.text.trim();

                    if (destinatarioTransacao.isEmpty || tipoTransacao.isEmpty || valorTransacao.isEmpty || dataTransacao.isEmpty) {
                      DialogMessage.showMessage(
                        context: _context!,
                        title: 'Erro',
                        message: 'Por favor, preencha todos os campos.',
                      );
                      return;
                    }

                    try {
                      double valor = double.tryParse(valorTransacao) ?? 0.0;
                      if (valor == 0.0) {
                        DialogMessage.showMessage(
                          context: _context!,
                          title: 'Erro',
                          message: 'Valor inválido. Tente novamente.',
                        );
                        return;
                      }

                      await _firebaseService.updateTransaction(
                        widget.transaction['transactionId'],
                        {
                          'transactionId': widget.transaction['transactionId'],
                          'destinatario': destinatarioTransacao,
                          'tipo_transacao': tipoTransacao,
                          'valor': valor,
                          'data': dataTransacao,
                        },
                        widget.transactions,
                      );

                      DialogMessage.showMessage(
                        context: _context!,
                        title: 'Sucesso',
                        message: 'Sua transação foi atualizada.',
                        onConfirmed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ListTransactions()),
                          );
                        },
                      );

                    } catch (e) {
                      DialogMessage.showMessage(
                        context: _context!,
                        title: 'Erro',
                        message: 'Falha ao atualizar transação. Tente novamente.',
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
