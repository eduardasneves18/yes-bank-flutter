import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String _lastTransactionId = "";
  int startAt = 0;
  int endAt = 7;
  bool executeSublist = false;

  Future<UserCredential> createUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
      }

      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'ERROR_CREATE_USER',
        message: 'Falha ao criar o usuário: ${e.toString()}',
      );
    }
  }

  Future<UserCredential> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      throw FirebaseAuthException(message: 'Falha ao autenticar. Tente novamente.', code: '');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> createTransaction(String destinatario, String tipoTransacao, double valor, String data) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('Nenhum usuário autenticado');
      }

      String userId = user.uid;

      DatabaseReference newTransactionRef = _database.child('transacoes').push();

      await newTransactionRef.set({
        'usuario_id': userId,
        'destinatario': destinatario,
        'tipo_transacao': tipoTransacao,
        'valor': valor,
        'data': data,
      });
    } catch (e) {
      throw Exception('Falha ao criar a transação: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String usuarioId) async {
    final DatabaseEvent snapshot = await _database
        .child('transacoes')
        .orderByChild('usuario_id')
        .equalTo(usuarioId)
        .once();

    List<Map<String, dynamic>> transactions = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> transacoes = snapshot.snapshot.value as Map<dynamic, dynamic>;

      transacoes.forEach((key, value) {
        transactions.add({
          'transactionId': key,
          'destinatario': value['destinatario'],
          'tipo_transacao': value['tipo_transacao'],
          'valor': value['valor'],
          'data': value['data'],
        });
      });

      transactions.sort((a, b) {
        DateFormat dateFormat = DateFormat('dd/MM/yyyy');

        DateTime dateA = dateFormat.parse(a['data']);
        DateTime dateB = dateFormat.parse(b['data']);

        return dateA.compareTo(dateB);
      });
    }

    return transactions;
  }

  Future<List<Map<String, dynamic>>> getTransactionsFiltered({
    String? tipoTransacao,
    String? destinatario,
    double? valor,
    String? data,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    String userId = user.uid;
    Query query = _database.child('transacoes').orderByChild('usuario_id').equalTo(userId);

    final DatabaseEvent snapshot = await query.once();

    List<Map<String, dynamic>> transactions = [];

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> transacoes = snapshot.snapshot.value as Map<dynamic, dynamic>;

      transacoes.forEach((key, value) {
        transactions.add({
          'transactionId': key,
          'destinatario': value['destinatario'],
          'tipo_transacao': value['tipo_transacao'],
          'valor': value['valor'],
          'data': value['data'],
        });
      });
    }

    if (tipoTransacao != null) {
      transactions = transactions.where((transaction) =>
          transaction['tipo_transacao'].toString().toLowerCase().contains(tipoTransacao.toLowerCase())
      ).toList();
    }

    if (destinatario != null) {
      transactions = transactions.where((transaction) =>
          transaction['destinatario'].toString().toLowerCase().contains(destinatario.toLowerCase())
      ).toList();
    }

    if (valor != null) {
      transactions = transactions.where((transaction) =>
      transaction['valor'] == valor
      ).toList();
    }

    if (data != null) {
      transactions = transactions.where((transaction) =>
          transaction['data'].toString().contains(data)
      ).toList();
    }

    return transactions;
  }

  Future<void> updateTransaction(String transactionId, String destinatario, String tipoTransacao, double valor, String data) async {
    await _database.child('transacoes/$transactionId').update({
      'destinatario': destinatario,
      'tipo_transacao': tipoTransacao,
      'valor': valor,
      'data': data,
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _database.child('transacoes/$transactionId').remove();
  }

  Future<User?> signInWithEmailPassword(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<List<Map<String, dynamic>>> getTransactionsPagination(String usuarioId, {String? lastTransactionId}) async {

    try {
      if (!executeSublist && startAt > 0) {
        return [];
      }

      Query query = _database
          .child('transacoes')
          .orderByChild('usuario_id')
          .equalTo(usuarioId);

      if (lastTransactionId != null &&
          lastTransactionId != _lastTransactionId) {
        _lastTransactionId = lastTransactionId;
        startAt += 7;
        endAt += 7;
        executeSublist = true;
      } else {
        executeSublist = true;
      }


      final DatabaseEvent snapshot = await query.once();

      List<Map<String, dynamic>> transactions = [];

      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> transacoes = snapshot.snapshot.value as Map<
            dynamic,
            dynamic>;

        transacoes.forEach((key, value) {
          transactions.add({
            'transactionId': key,
            'destinatario': value['destinatario'],
            'tipo_transacao': value['tipo_transacao'],
            'valor': value['valor'],
            'data': value['data'],
          });
        });

        if (executeSublist && startAt > 0) {
          transactions = transactions.sublist(startAt, endAt);
        }

        transactions.sort((a, b) {
          DateFormat dateFormat = DateFormat('dd/MM/yyyy');
          DateTime dateA = dateFormat.parse(a['data']);
          DateTime dateB = dateFormat.parse(b['data']);
          return dateA.compareTo(dateB);
        });
      }

      return transactions;
    } catch (e) {
      print(e);
      return [];
    }
  }


}
