import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yes_bank/components/dialogs/yb_dialog_message.dart';
import 'package:yes_bank/screens/transactions/edit_transaction.dart';

import '../../components/filters/yb_transactions_filter.dart';
import '../../components/screens/yb_app_bar.dart';
import '../../components/yb_menu.dart';
import '../../services/cache/transaction_cache_service.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';
import '../../utils/user_auth_checker.dart';
import '../signout/login/login.dart';

class ListTransactions extends StatefulWidget {
  @override
  _ListTransactionsState createState() => _ListTransactionsState();
}

class _ListTransactionsState extends State<ListTransactions> {
  final TransactionsFirebaseService _firebaseService = TransactionsFirebaseService();
  final TransactionCacheService _cacheService = TransactionCacheService();

  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  String? _lastTransactionId;

  final ScrollController _scrollController = ScrollController();
  bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    _checkUserAndLoadTransactions();
    _scrollController.addListener(_scrollListener);
  }

  void _checkUserAndLoadTransactions() {
    UserAuthChecker.check(
      context: context,
      onAuthenticated: () {
        _initializeTransactions();
      },
    );
  }

  Future<void> _initializeTransactions() async {
    final cachedTransactions = await _cacheService.getTransactions();
    if (!mounted) return;

    if (cachedTransactions.isNotEmpty) {
      setState(() {
        _transactions = cachedTransactions;
        _isLoading = false;
      });
    } else {
      await _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      List<Map<String, dynamic>> transactions = await _firebaseService.getTransactionsPagination(
        user.uid,
        lastTransactionId: _lastTransactionId,
      );

      if (!mounted) return;

      if (transactions.isNotEmpty) {
        setState(() {
          _lastTransactionId = transactions.last['transactionId'];

          final newTransactionIds = transactions.map((t) => t['transactionId']).toSet();
          _transactions.removeWhere((t) => newTransactionIds.contains(t['transactionId']));
          _transactions.addAll(transactions);
        });

        await _cacheService.saveTransactions(_transactions);
      }
    } catch (e) {
      await DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Falha ao carregar transações. Tente novamente.',
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadTransactions();
    }
  }

  void _showTransactionOptions(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Color(0xFF004D61)),
                title: Text('Alterar Transação'),
                onTap: () {
                  Navigator.pop(context);
                  _editTransaction(transaction, _transactions);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Deletar Transação'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteTransaction(transaction, _transactions);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _editTransaction(Map<String, dynamic> transaction, _transactions) async {
    await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransaction(transaction: transaction, transactions: _transactions),
      ),
    );
  }

  Future<void> _deleteTransaction(Map<String, dynamic> transaction, List<Map<String, dynamic>> transactions) async {
    try {
      await _firebaseService.deleteTransaction(
        transaction['transactionId'],
        _transactions,
      );
      if (!mounted) return;
      await DialogMessage.showMessage(
        context: context,
        title: 'Sucesso',
        message: 'Transação deletada!',
        onConfirmed: () {
          _initializeTransactions();
        },
      );
    } catch (e) {
      if (!mounted) return;
      await DialogMessage.showMessage(
        context: context,
        title: 'Erro',
        message: 'Falha ao deletar transação. Tente novamente.',
      );
    }
  }

  void _onFilterApplied(List<Map<String, dynamic>> transactions) {
    setState(() {
      _filteredTransactions = transactions;
      _isFiltering = true;
    });
  }

  void _clearFilter() {
    setState(() {
      _filteredTransactions = [];
      _isFiltering = false;
    });
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return YbTransactionsFilter(onFilterApplied: _onFilterApplied);
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

    final displayedTransactions = _isFiltering ? _filteredTransactions : _transactions;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: Menu(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B0B0B),
                  Color(0xFF212121),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista de Transações',
                  style: TextStyle(
                    fontSize: sizeScreen.width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _openFilterModal,
                ),
              ],
            ),
          ),
          if (_isFiltering)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _clearFilter,
                child: Text('Limpar Filtro'),
              ),
            ),
          Expanded(
            child: Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF212121),
                    Color(0xFF666666),
                  ],
                ),
              ),
              child: _isLoading && _transactions.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : displayedTransactions.isEmpty
                  ? Center(child: Text('Não há transações para exibir.'))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: displayedTransactions.length + (_isFetchingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == displayedTransactions.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var transaction = displayedTransactions[index];
                  return Card(
                    color: Colors.transparent,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      textColor: Colors.white,
                      title: Text(
                        '${transaction['destinatario']}',
                        style: TextStyle(
                          fontSize: sizeScreen.width * 0.05,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tipo transação: ${transaction['tipo_transacao']}'),
                          Text('Valor: R\$ ${transaction['valor']}'),
                        ],
                      ),
                      trailing: Text(transaction['data']),
                      onTap: () {
                        _showTransactionOptions(transaction);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
