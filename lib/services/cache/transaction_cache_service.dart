import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionCacheService {
  static const String _cacheKey = 'transactions_cache';

  Future<void> saveTransactions(List<Map<String, dynamic>> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactionsJson = transactions.map((transaction) {
      return json.encode(transaction);
    }).toList();
    await prefs.setStringList(_cacheKey, transactionsJson);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionsJson = prefs.getStringList(_cacheKey);

    if (transactionsJson != null) {
      return transactionsJson.map((transaction) {
        return json.decode(transaction) as Map<String, dynamic>;
      }).toList();
    }
    return [];
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
