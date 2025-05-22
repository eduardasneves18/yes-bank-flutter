import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

import '../../cache/transaction_cache_service.dart';
import '../firebase.dart';
import '../users/user_firebase.dart';

class TransactionsFirebaseService {
  final FirebaseServiceGeneric _firebaseService = FirebaseServiceGeneric();
  final TransactionCacheService _cacheService = TransactionCacheService();
  final UsersFirebaseService _usersService = UsersFirebaseService();

  String _lastTransactionId = "";
  int startAt = 0;
  int endAt = 7;
  bool executeSublist = false;

  Future<void> createTransaction(
      String destinatario,
      String tipoTransacao,
      double valor,
      String data,
      ) async {
    try {
      User? user = await _usersService.getUser();
      if (user == null) throw Exception('Nenhum usuário autenticado');

      List<Map<String, dynamic>> transactions = [];
      String userId = user.uid;

      await _firebaseService.create('transacoes', {
        'usuario_id': userId,
        'destinatario': destinatario,
        'tipo_transacao': tipoTransacao,
        'valor': valor,
        'data': data,
      });

      await _cacheService.clearCache();

      transactions = await getTransactionsPagination(
        user.uid,
        lastTransactionId: _lastTransactionId,
      );

      await _cacheService.saveTransactions(transactions);
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

  Future<void> updateTransaction(String transactionId, Map<String, dynamic> data, List<Map<String, dynamic>> transactions,) async {
    await _firebaseService.update('transacoes', transactionId, data);

    final index = transactions.indexWhere((t) => t['transactionId'] == transactionId);
    if (index != -1) {
      transactions[index] = data;
      await _cacheService.saveTransactions(transactions);
    }
  }

  Future<void> deleteTransaction(
      String transactionId,
      List<Map<String, dynamic>> transactions,
      ) async {
    await _firebaseService.delete('transacoes', transactionId);
    transactions.removeWhere((t) => t['transactionId'] == transactionId);
    await _cacheService.saveTransactions(transactions);
  }

  Future<List<Map<String, dynamic>>> getTransactionsFiltered({
    String? tipoTransacao,
    String? destinatario,
    double? valor,
    String? data,
  }) async {
    User? user = await _usersService.getUser();
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

  Future<List<Map<String, dynamic>>> getTransactionsPagination(String usuarioId, {String? lastTransactionId,}) async {
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
