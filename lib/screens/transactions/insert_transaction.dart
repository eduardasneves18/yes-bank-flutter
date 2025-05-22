import 'package:flutter/material.dart';
import 'package:yes_bank/components/dialogs/yb_dialog_message.dart';
import 'package:yes_bank/components/fields/yb_dropdown_field.dart';
import 'package:yes_bank/components/fields/yb_text_field.dart';
import 'package:yes_bank/screens/signout/login/login.dart';
import 'package:yes_bank/screens/transactions/list_transactions.dart';
import '../../components/fields/yb_number_field.dart';
import '../../components/screens/yb_app_bar.dart';
import '../../components/fields/yb_date_field.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';
import '../../services/firebase/users/user_firebase.dart';
import '../../services/firebase/sessions/sessionManager.dart';
import '../../services/firebase/login/login_firebase.dart';
import '../../models/cliente.dart';
import '../../store/cliente_store.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/user_auth_checker.dart';

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
  bool _userChecked = false;
  bool _userAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }
  void _checkUser() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () {
        setState(() {
          _userChecked = true;
          _userAuthenticated = true;
        });
      },
    );
  }
  // void _checkUser() async {
  //   final userService = UsersFirebaseService();
  //   final user = await userService.getUser();
  //
  //   if (user == null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       DialogMessage.showMessage(
  //         context: context,
  //         title: 'Erro',
  //         message: 'Usuário não autenticado. Por favor, faça login novamente.',
  //         onConfirmed: () async {
  //           final usersService = UsersFirebaseService();
  //           User? user = await usersService.getUser();
  //
  //           if (user?.uid == null) {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(builder: (context) => Login()),
  //             );
  //           };
  //         },
  //       );
  //     });
  //   }
  //   setState(() {
  //     _userChecked = true;
  //     _userAuthenticated = user != null;
  //   });
  // }

  void _clearFields() {
    _destinatarioController.clear();
    _valorController.clear();
    _dataController.clear();
    setState(() {
      _selectedTipoTransacao = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

    return ComponenteGeral(
      sizeScreen: sizeScreen,
      child: !_userChecked
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            SizedBox(height: sizeScreen.height * 0.02),
            if (_userAuthenticated) ...[
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
                hint: '---',
                dropdownColor: Colors.black,
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
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      String destinatario = _destinatarioController.text.trim();
                      String tipo = _selectedTipoTransacao ?? '';
                      String valorTexto = _valorController.text.trim();
                      String data = _dataController.text.trim();

                      if (destinatario.isEmpty || tipo.isEmpty || valorTexto.isEmpty || data.isEmpty) {
                        DialogMessage.showMessage(
                          context: context,
                          title: 'Erro',
                          message: 'Por favor, preencha todos os campos.',
                        );
                        return;
                      }

                      try {
                        double valor = double.tryParse(valorTexto) ?? 0.0;
                        if (valor <= 0.0) {
                          DialogMessage.showMessage(
                            context: context,
                            title: 'Erro',
                            message: 'Valor inválido.',
                          );
                          return;
                        }

                        await _firebaseService.createTransaction(destinatario, tipo, valor, data);

                        _clearFields();

                        DialogMessage.showMessage(
                          context: context,
                          title: 'Sucesso',
                          message: 'Sua transação foi realizada.',
                          onConfirmed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ListTransactions()),
                            );
                          },
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
            ]
          ],
        ),
      ),
    );
  }
}
