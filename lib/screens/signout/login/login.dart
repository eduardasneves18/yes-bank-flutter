import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yes_bank/components/fields/yb_text_field.dart';
import 'package:yes_bank/screens/signout/register/register.dart';
import 'package:yes_bank/screens/transactions/insert_transaction.dart';

import '../../../components/dialogs/yb_dialog_message.dart';
import '../../../database/firebase_database.dart';
import '../../home/home_dashboard.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _senhaController = TextEditingController();
final FirebaseService _firebaseService = FirebaseService();

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000),
              Color(0xFF666666),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: sizeScreen.width * 0.05,
        ),
        width: sizeScreen.width,
        height: sizeScreen.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Welcome(sizeScreen: sizeScreen),
              GestureDetector(
                child: Form(sizeScreen: sizeScreen),
                onTap: () => FocusScope.of(context).unfocus(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  final Size sizeScreen;

  const Welcome({Key? key, required this.sizeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'YesBank',
            style: TextStyle(
              fontSize: sizeScreen.width * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.yellow[700],
            ),
          ),
          Text(
            'Faça seu login para continuar',
            style: TextStyle(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

class Form extends StatelessWidget {
  final Size sizeScreen;

  const Form({Key? key, required this.sizeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: sizeScreen.width * 0.05),
      child: Column(
        children: <Widget>[
          YBTextField(
            controller: _emailController,
            sizeScreen: sizeScreen,
            icon: Icons.mail_outline,
            hint: 'E-mail',
            borderColor: Colors.black,
            textColor: Colors.grey,
            cursorColor: Colors.black,
            fillColor: Colors.transparent,
            labelColor: Colors.white,
            security: null,
          ),
          YBTextField(
            controller: _senhaController,
            sizeScreen: sizeScreen,
            icon: Icons.lock_outline,
            hint: 'Senha',
            borderColor: Colors.black,
            textColor: Colors.grey,
            cursorColor: Colors.black,
            fillColor: Colors.transparent,
            security: true,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: sizeScreen.height * 0.01,
                horizontal: sizeScreen.height * 0.025),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Ainda não possui uma conta? ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      TextSpan(
                        text: 'Cadastre-se',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: sizeScreen.height * 0.03),
            child: SizedBox(
              width: sizeScreen.width * 0.70,
              height: sizeScreen.width * 0.12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004D61),
                  foregroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String senha = _senhaController.text.trim();

                  if (email.isEmpty) {
                    DialogMessage.showMessage(
                      context: context,
                      title: 'Erro',
                      message: 'Por favor, digite seu e-mail.',
                    );
                    return;
                  }

                  if (senha.isEmpty) {
                    DialogMessage.showMessage(
                      context: context,
                      title: 'Erro',
                      message: 'Por favor, digite sua senha.',
                    );
                    return;
                  }

                  try {
                    await _firebaseService.loginWithEmailPassword(email, senha);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeDashboard(),
                      ),
                    );
                  } catch (e) {
                    DialogMessage.showMessage(
                      context: context,
                      title: 'Erro',
                      message: 'Falha ao realizar o login. Tente novamente.',
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
