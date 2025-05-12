import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_bank/services/firebase/login/login_firebase.dart';

import '../models/cliente.dart';
import '../screens/home/home_dashboard.dart';
import '../screens/signout/login/login.dart';
import '../screens/transactions/insert_transaction.dart';
import '../screens/transactions/list_transactions.dart';
import '../services/firebase/sessions/sessionManager.dart';
import '../services/firebase/users/user_firebase.dart';
import '../store/cliente_store.dart';

class Menu extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
  final ClienteStore _clienteStore = Provider.of<ClienteStore>(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF0B0B0B),
                  Color(0xFF151515),
                ],
              ),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Tela Inicial'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeDashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text('Novas transações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Transaction()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.request_page),
            title: Text('Lista de transações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListTransactions()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.output),
            title: Text('Sair'),
            onTap: () async {
              final usersService = UsersFirebaseService();
              final loginService = LoginFirebaseAuthService();

              User? user = await usersService.getUser();

              if (user?.uid != null) {
                Cliente cliente = Cliente(
                  id: user!.uid,
                  email: user.email,
                  nome: user.displayName,
                );

                final sessionManager = SessionManager(
                  loginService,
                  cliente,
                  _clienteStore,
                );

                await sessionManager.logout();
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
