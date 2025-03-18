import 'package:sqflite/sqflite.dart';
import 'package:yes_bank/database/app_database.dart';
import 'package:yes_bank/models/cliente.dart';

class ClienteDao {
  static const String _tableName = 'cliente';
  static const String _id = 'id';
  static const String _email = 'email';
  static const String _senha = 'senha';
  static const String _nome = 'nome';
  static const String _primeiroNome = 'primeiroNome';
  static const String _ultimoNome = 'ultimoNome';
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_email TEXT, '
      '$_nome TEXT, '
      '$_primeiroNome TEXT, '
      '$_ultimoNome TEXT, '
      '$_senha TEXT)';

  Future<int> save(Cliente cliente) async {
    final Database db = await getDatabase();
    Map<String, dynamic> clienteMap = _toMap(cliente);
    return db.insert(_tableName, clienteMap);
  }

  delete(Cliente cliente) async {
    final Database db = await getDatabase();
    final codCliente = cliente.id;
    db.delete(_tableName, where: 'id = $codCliente');
  }

  Future<Cliente> get() async {
    Cliente selectedCliente = Cliente();
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result =
    await db.query(_tableName, limit: 1);

    for (Map<String, dynamic> row in result) {
      selectedCliente = Cliente(
          id: row[_id],
          password: row[_senha],
          nome: row[_nome],
          primeiroNome: row[_primeiroNome],
          ultimoNome: row[_ultimoNome],
          email: row[_email],
      );
    }
    return selectedCliente;
  }

  Map<String, dynamic> _toMap(Cliente cliente) {
    final Map<String, dynamic> clienteMap = Map();
    clienteMap[_nome] = cliente.nome;
    clienteMap[_senha] = cliente.password;
    clienteMap[_email] = cliente.email;
    clienteMap[_primeiroNome] = cliente.primeiroNome;
    clienteMap[_ultimoNome] = cliente.ultimoNome;
    return clienteMap;
  }

  List<Cliente> _toList(List<Map<String, dynamic>> result) {
    final List<Cliente> clientes = [];
    for (Map<String, dynamic> row in result) {
      final Cliente cliente = Cliente(
        id: row[_id],
        email: row[_email],
        nome: row[_nome],
      );
      clientes.add(cliente);
    }
    return clientes;
  }

  Future<List<Cliente>> getCliente() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result =
    await db.query(_tableName, limit: 1);
    List<Cliente> clientes = _toList(result);
    return clientes;
  }
}
