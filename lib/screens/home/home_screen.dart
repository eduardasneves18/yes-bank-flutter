import 'package:provider/provider.dart';
import 'package:yes_bank/components/screens/loading_screen.dart';
import 'package:yes_bank/database/dao/client_dao.dart';
import 'package:yes_bank/models/cliente.dart';
import 'package:yes_bank/ui/orientation_layout.dart';
import 'package:yes_bank/ui/screen_type_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../store/cliente_store.dart';
import '../signout/login/login.dart';
import 'home_dashboard.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayout(
        portrait: _setFirstScreen(context),
      ),
    );
  }

  Widget _setFirstScreen(BuildContext context) {
    ClienteDao _clienteDao = ClienteDao();
    final clienteStore = Provider.of<ClienteStore>(context);
    final selectedCliente = clienteStore.cliente;

    return selectedCliente.id != null
        ? Container(child: Text("Teste logadoteste"),)
        : FutureBuilder<Cliente>(
      future: _clienteDao.get(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return HomeDashboard();
          case ConnectionState.waiting:
            return LoadingScreen();
          case ConnectionState.active:
            return Container(
                color: Colors.white

            );
          case ConnectionState.done:
            if (snapshot.data != null && snapshot.hasData) {
              // this._loginWithSavedUser(cliente, clienteStore, context);
              return HomeDashboard();
            } else {
              return Login();
            }
        }
      },
    );
  }

}