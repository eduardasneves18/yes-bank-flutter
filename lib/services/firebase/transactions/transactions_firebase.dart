import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../firebase.dart';

class TransactionsFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();

  String _lastTransactionId = "";
  int startAt = 0;
  int endAt = 7;
  bool executeSublist = false;

  Future<void> createTransaction(
      String destinatario, String tipoTransacao, double valor, String data) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('Nenhum usuário autenticado');

      String userId = user.uid;

      await _firebaseService.create('transacoes', {
        'usuario_id': userId,
        'destinatario': destinatario,
        'tipo_transacao': tipoTransacao,
        'valor': valor,
        'data': data,
      });
    } catch (e) {
      throw Exception('Erro ao criar transação: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String usuarioId) async {
    final DatabaseEvent snapshot = await _firebaseService.fetch('transacoes');
    List<Map<String, dynamic>> transactions = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> transacoes = snapshot.snapshot.value as Map;

      transacoes.forEach((key, value) {
        if (value['usuario_id'] == usuarioId) {
          transactions.add({
            'transactionId': key,
            'destinatario': value['destinatario'],
            'tipo_transacao': value['tipo_transacao'],
            'valor': value['valor'],
            'data': value['data'],
          });
        }
      });

      transactions.sort((a, b) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
        return dateFormat.parse(a['data']).compareTo(dateFormat.parse(b['data']));
      });
    }

    return transactions;
  }

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> data) async {
    await _firebaseService.update('transacoes', transactionId, data);
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _firebaseService.delete('transacoes', transactionId);
  }

  Future<List<Map<String, dynamic>>> getTransactionsFiltered({
    String? tipoTransacao,
    String? destinatario,
    double? valor,
    String? data,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    List<Map<String, dynamic>> transactions = await getTransactions(user.uid);

    if (tipoTransacao != null) {
      transactions = transactions
          .where((t) => t['tipo_transacao'].toLowerCase().contains(tipoTransacao.toLowerCase()))
          .toList();
    }
    if (destinatario != null) {
      transactions = transactions
          .where((t) => t['destinatario'].toLowerCase().contains(destinatario.toLowerCase()))
          .toList();
    }
    if (valor != null) {
      transactions = transactions.where((t) => t['valor'] == valor).toList();
    }
    if (data != null) {
      transactions = transactions.where((t) => t['data'].contains(data)).toList();
    }

    return transactions;
  }

  Future<List<Map<String, dynamic>>> getTransactionsPagination(
      String usuarioId, {String? lastTransactionId}) async {
    try {
      if (!executeSublist && startAt > 0) {
        return [];
      }

      List<Map<String, dynamic>> transactions = await getTransactions(usuarioId);

      if (lastTransactionId != null && lastTransactionId != _lastTransactionId) {
        _lastTransactionId = lastTransactionId;
        startAt += 7;
        endAt += 7;
      }

      if (executeSublist && startAt < transactions.length) {
        transactions = transactions.sublist(startAt, endAt.clamp(0, transactions.length));
      }

      return transactions;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
