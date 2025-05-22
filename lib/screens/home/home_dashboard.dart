import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yes_bank/components/charts/yb_transaction_chart.dart';
import '../../components/screens/yb_app_bar.dart';
import '../../services/firebase/users/user_firebase.dart';
import '../transactions/insert_transaction.dart';
import '../transactions/list_transactions.dart';

class HomeDashboard extends StatelessWidget {
  final UsersFirebaseService usersService = UsersFirebaseService();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

    return FutureBuilder<User?>(
      future: usersService.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          body: ComponenteGeral(
            sizeScreen: sizeScreen,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Bem-vindo(a), ${user?.displayName ?? ''}!',
                          style: TextStyle(
                            fontSize: sizeScreen.width * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: sizeScreen.height * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      children: [
                        Card(
                          color: Colors.transparent,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            textColor: Colors.white,
                            title: Text(
                              'Saldo:',
                              style: TextStyle(
                                fontSize: sizeScreen.width * 0.05,
                              ),
                            ),
                            trailing: Text(
                              '0,00',
                              style: TextStyle(
                                fontSize: sizeScreen.width * 0.05,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gráficos de análise de transações',
                                  style: TextStyle(
                                    fontSize: sizeScreen.width * 0.04,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: sizeScreen.height * 0.02),
                                TransactionsBarChart(),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Card(
                                color: Colors.transparent,
                                margin: EdgeInsets.all(9),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: sizeScreen.height * 0.02),
                                        Center(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Transaction(),
                                                ),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.swap_horiz,
                                              color: Colors.white,
                                              size: sizeScreen.width * 0.10,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            'Nova transação',
                                            style: TextStyle(
                                              fontSize: sizeScreen.width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                color: Colors.transparent,
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: sizeScreen.height * 0.02),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ListTransactions(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.request_page,
                                            color: Colors.white,
                                            size: sizeScreen.width * 0.09,
                                          ),
                                        ),
                                        Text(
                                          'Extrato',
                                          style: TextStyle(
                                            fontSize: sizeScreen.width * 0.04,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
