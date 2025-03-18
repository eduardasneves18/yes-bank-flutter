// import 'dart:convert';
// import 'package:yes_bank/api/services/main_service.dart';
// import 'package:yes_bank/api/webclient.dart';
// import 'package:yes_bank/models/cliente.dart';
// import 'package:yes_bank/models/message_schedule.dart';
// import 'package:http/http.dart';
//
// class RegisterClienteService extends MainService {
//   Future<MessageSchedule> register({
//     String name,
//     String email,
//     String senha,
//   }) async {
//     final String userJson = jsonEncode(Cliente(
//       email: email,
//       nome: name,
//       password: senha,
//     ).toRegisterJson());
//     final Response response = await client.post('$baseUrl/cliente',
//         headers: {
//           'Content-type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: userJson);
//     switch (response.statusCode) {
//       case 200:
//         if (response.body != 'null') {
//           return MessageSchedule(
//               codigo: 1, mensagem: 'Cliente cadastrado com sucesso.');
//         } else {
//           _throwHttpError(999);
//         }
//         break;
//       default:
//         _throwHttpError(response.statusCode);
//         break;
//     }
//     return null;
//   }
//
//   Cliente _toCliente(Response response) {
//     final Map<String, dynamic> decodedJson =
//     jsonDecode(utf8.decode(response.bodyBytes));
//     final Cliente cliente = Cliente.fromJson(decodedJson);
//     return cliente;
//   }
//
//   Future<Cliente> getClienteByEmail(String emailCliente) async {
//     final Response response = await client.get(
//         '$baseUrl/cliente/socialLogin/${emailCliente.toLowerCase()}',
//         headers: {
//           'Content-type': 'application/json; charset=utf-8',
//           'Accept': 'application/json',
//         });
//     switch (response.statusCode) {
//       case 200:
//         if (response.body != 'null') {
//           return _toCliente(response);
//         } else {
//           return null;
//         }
//         break;
//       default:
//         _throwHttpError(response.statusCode);
//         break;
//     }
//     return null;
//   }
//
//   static final Map<int, String> _statusCodeResponses = {
//     400: 'Ocorreu erro durante o processo',
//     999: 'O e-mail informado já está em uso!',
//     404: 'Servidor não pode responder',
//     401: 'Falha na autenticação',
//     409: 'Serviço já está em uso',
//   };
//
//   String _getMessage(int statusCode) {
//     if (_statusCodeResponses.containsKey(statusCode)) {
//       return _statusCodeResponses[statusCode];
//     } else {
//       return 'Unknwon error';
//     }
//   }
//
//   void _throwHttpError(int statusCode) =>
//       throw HttpException(_getMessage(statusCode));
// }
//
// class HttpException implements Exception {
//   final String message;
//
//   HttpException(this.message);
// }
