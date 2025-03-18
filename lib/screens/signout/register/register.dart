import 'package:yes_bank/components/fields/yb_text_field.dart';
import 'package:flutter/material.dart';
import '../../../components/dialogs/yb_dialog_message.dart';
import '../../../database/firebase_database.dart';
import '../../transactions/insert_transaction.dart'  as transaction_screen;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseService _firebaseService = FirebaseService();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final Size sizeScreen = media.size;
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
                child: Form(
                  sizeScreen: sizeScreen,
                  firebaseService: _firebaseService,
                  nameController: _nameController,
                  emailController: _emailController,
                  passController: _passController,
                  confirmPassController: _confirmPassController,
                ),
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
    return Column(
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
          'Cadastro',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class Form extends StatelessWidget {
  final Size sizeScreen;
  final FirebaseService firebaseService;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController confirmPassController;

  const Form({
    Key? key,
    required this.sizeScreen,
    required this.firebaseService,
    required this.nameController,
    required this.emailController,
    required this.passController,
    required this.confirmPassController,
  }) : super(key: key);

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType textType = TextInputType.text, bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: YBTextField(
        controller: controller,
        labelColor: Colors.white,
        sizeScreen: sizeScreen,
        iconColor: Colors.black,
        hint: hint,
        hintColor: Colors.white,
        fillColor: Color.fromRGBO(1, 1, 1, 0.2),
        cursorColor: Colors.white,
        textType: textType,
        borderColor: Colors.black,
        textColor: Colors.white,
        security: obscureText,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: sizeScreen.width * 0.02),
      child: SizedBox(
        width: sizeScreen.width * 0.90,
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
            'Cadastrar',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async {
            String email = emailController.text.trim();
            String senha = passController.text.trim();
            String confirmSenha = confirmPassController.text.trim();
            String name = nameController.text.trim();

            if (name.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite seu nome.');
              return;
            }

            if (email.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite seu e-mail.');
              return;
            }

            if (senha.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, digite sua senha.');
              return;
            }

            if (confirmSenha.isEmpty) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Por favor, confirme sua senha.');
              return;
            }

            if (senha != confirmSenha) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'As senhas não coincidem.');
              return;
            }

            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => transaction_screen.Transaction()
                ),
              );

            } catch (e) {
              DialogMessage.showMessage(context: context, title: 'Erro', message: 'Falha ao criar o usuário. Tente novamente.');
            }
          },
        ),
      ),
    );
  }

  // Método para o ícone de voltar
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(top: sizeScreen.width * 0.05, left: 15.0),
        child: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: sizeScreen.width * 0.12,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField(nameController, 'Nome', Icons.person,obscureText: false),
        _buildTextField(emailController, 'E-mail', Icons.email, textType: TextInputType.emailAddress, obscureText: false),
        _buildTextField(passController, 'Senha', Icons.lock_outline, obscureText: true),
        _buildTextField(confirmPassController, 'Confirmar senha', Icons.lock_outline, obscureText: true),
        _buildRegisterButton(context),
        _buildBackButton(context),
      ],
    );
  }
}
