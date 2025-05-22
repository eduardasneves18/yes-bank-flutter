import 'package:flutter/material.dart';
import 'package:yes_bank/components/dialogs/yb_dialog_message.dart';
import 'package:yes_bank/screens/signout/login/login.dart';
import 'package:yes_bank/services/firebase/users/user_firebase.dart';

class UserAuthChecker {
  static Future<void> check({
    required BuildContext context,
    required VoidCallback onAuthenticated,
  }) async {
    final userService = UsersFirebaseService();
    final user = await userService.getUser();

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DialogMessage.showMessage(
          context: context,
          title: 'Erro',
          message: 'Usuário não autenticado. Por favor, faça login novamente.',
          onConfirmed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        );
      });
    } else {
      onAuthenticated();
    }
  }
}
