import 'package:flutter/material.dart';
import 'package:yes_bank/components/dialogs/yb_dialog_message.dart';
import 'package:yes_bank/components/fields/yb_dropdown_field.dart';
import 'package:yes_bank/components/fields/yb_text_field.dart';
import '../../components/fields/yb_number_field.dart';
import '../../components/screens/yb_app_bar.dart';
import '../../components/fields/yb_date_field.dart';
import '../../services/firebase/firebase.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';

final TextEditingController _destinatarioController = TextEditingController();
final TextEditingController _valorController = TextEditingController();
final TextEditingController _dataController = TextEditingController();
final TransactionsFirebaseService _firebaseService = TransactionsFirebaseService();

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  String? _selectedTipoTransacao;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

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
                    'Nova transação',
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
                  security: null,
                  borderColor: Colors.black,
                  textColor: Colors.grey,
                  cursorColor: Colors.black,
                  fillColor: Colors.transparent,
                  labelColor: Colors.white,
                  labelText: 'Destinatário',
                ),
                YBDropdownField(
                  onChanged: (value) {
                    setState(() {
                      _selectedTipoTransacao = value;
                    });
                  },
                  sizeScreen: sizeScreen,
                  hint: 'Teste',
                  borderColor: Colors.black,
                  textColor: Colors.black,
                  fillColor: Colors.white,
                  labelColor: Colors.white,
                  labelText: 'Tipo de transação',
                  dropdownColor: Colors.white,
                ),
                YBNumberField(
                  controller: _valorController,
                  sizeScreen: sizeScreen,
                  hint: 'Valor',
                  borderColor: Colors.black,
                  textColor: Colors.grey,
                  cursorColor: Colors.black,
                  fillColor: Colors.transparent,
                  labelColor: Colors.white,
                  labelText: 'Valor',
                ),
                YBDateField(
                  controller: _dataController,
                  sizeScreen: sizeScreen,
                  hint: 'Data',
                  borderColor: Colors.black,
                  textColor: Colors.grey,
                  cursorColor: Colors.black,
                  fillColor: Colors.transparent,
                  labelColor: Colors.white,
                  labelText: 'Data',
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
                    'Concluir transação',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed:  () async {
                    String destinatarioTransacao = _destinatarioController.text.trim();
                    String tipoTransacao = _selectedTipoTransacao ?? '';  // Use the selected value here
                    String valorTransacao = _valorController.text.trim();
                    String dataTransacao = _dataController.text.trim();

                    if (destinatarioTransacao.isEmpty || tipoTransacao.isEmpty || valorTransacao.isEmpty || dataTransacao.isEmpty) {
                      DialogMessage.showMessage(
                        context: context,
                        title: 'Erro',
                        message: 'Por favor, preencha todos os campos.',
                      );
                      return;
                    }

                    try {
                      double valor = double.tryParse(valorTransacao) ?? 0.0;
                      if (valor == 0.0) {
                        DialogMessage.showMessage(
                          context: context,
                          title: 'Erro',
                          message: 'Valor inválido. Tente novamente.',
                        );
                        return;
                      }

                      await _firebaseService.createTransaction(
                        destinatarioTransacao,
                        tipoTransacao,
                        valor,
                        dataTransacao,
                      );
                      DialogMessage.showMessage(
                        context: context,
                        title: 'Sucesso',
                        message: 'Sua transação foi realizada.',
                      );


                    } catch (e) {
                      DialogMessage.showMessage(
                        context: context,
                        title: 'Erro',
                        message: 'Falha ao realizar a transação. Tente novamente.',
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
