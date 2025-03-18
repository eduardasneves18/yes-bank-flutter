// import 'package:es-bank-app/api/services/recovery_password.dart';
// import 'package:yes_bank-app/components/failure_screen.dart';
// import 'package:flutter/material.dart';
//
// import '../../../components/dialogs/yb_dialog_message.dart';
// import '../../../components/fields/yb_text_field.dart';
//
// class RecorevyPassword extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController _emailController = TextEditingController();
//
//     final MediaQueryData media = MediaQuery.of(context);
//     final Size sizeScreen = media.size;
//     final TextStyle _textStyle = TextStyle(
//       color: Colors.white,
//       fontSize: sizeScreen.width * 0.035,
//     );
//
//     return Scaffold(
//       body: Container(
//         padding: new EdgeInsets.only(
//           left: sizeScreen.width * 0.02,
//           right: sizeScreen.width * 0.02,
//           top: sizeScreen.width * 0.15,
//           bottom: sizeScreen.width * 0.05,
//         ),
//         height: sizeScreen.height,
//         width: sizeScreen.width,
//         decoration: BoxDecoration(
//           color: Theme.of(context).primaryColor,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: Column(
//                   children: <Widget>[
//                     Container(
//                       child: Text(
//                         'Beauty Clinic',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: sizeScreen.width * 0.08,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding:
//                       new EdgeInsets.only(top: sizeScreen.width * 0.05),
//                       child: Text(
//                         'Recuperar Senha',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: sizeScreen.width * 0.05),
//                       ),
//                     ),
//                     Container(
//                       padding:
//                       new EdgeInsets.only(top: sizeScreen.width * 0.05),
//                       child: Column(
//                         children: <Widget>[
//                           Text('Forneça seu e-mail cadastrado para',
//                               style: _textStyle),
//                           Text('solicitar o ínicio do processo de',
//                               style: _textStyle),
//                           Text('redefinição de sua senha.', style: _textStyle),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: new EdgeInsets.only(top: sizeScreen.width * 0.05),
//                 child: YBTextField(
//                   controller: _emailController,
// //                  labelText: 'E-mail',
//                   labelColor: Colors.white,
//                   sizeScreen: sizeScreen,
//                   icon: Icons.email,
//                   iconColor: Colors.white,
//                   hint: 'E-mail',
//                   hintColor: Colors.white,
//                   fillColor: Color.fromRGBO(1, 1, 1, 0.2),
//                   cursorColor: Colors.white,
//                   textType: TextInputType.emailAddress,
//                   borderColor: Colors.white,
//                   textColor: Colors.white,
//                 ),
//               ),
//               Container(
//                 margin: new EdgeInsets.only(top: sizeScreen.width * 0.02),
//                 child: SizedBox(
//                   width: sizeScreen.width * 0.90,
//                   height: sizeScreen.width * 0.12,
//                   child: RaisedButton(
//                     color: Color.fromRGBO(182, 20, 98, 0.1),
//                     child: Text(
//                       'ENVIAR',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                       side: BorderSide(color: Colors.white, width: 0.5),
//                     ),
//                     onPressed: () => _doRecovery(_emailController, context),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: new EdgeInsets.only(top: sizeScreen.width * 0.05),
//                 child: InkWell(
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: sizeScreen.width * 0.12,
//                   ),
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   _doRecovery(TextEditingController _emailController, BuildContext context) {
//     final String emailText = _emailController.text.toString();
//     if (emailText.isNotEmpty) {
//       RecoveryPasswordService _recoveryPassword = RecoveryPasswordService();
//       _recoveryPassword
//           .recovery(email: emailText)
//           .then((response) => DialogMessage.showMessage(context, 'Aviso', response.mensagem))
//           .catchError((error) {
//         DialogMessage.showMessage(context, 'Erro', error.message);
//       });
//     } else {
//       DialogMessage.showMessage(context, 'Erro', 'É necessário informar o E-mail');
//     }
//   }
// }
