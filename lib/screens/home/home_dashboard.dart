import 'package:flutter/material.dart';
import 'package:yes_bank/components/charts/yb_transaction_chart.dart';
import '../../components/screens/yb_app_bar.dart';

class HomeDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    final Size sizeScreen = data.size;

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
                      'Bem vindo(a)!',
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
                child: Text(
                  'Gráficos de analise de transações',
                  style: TextStyle(
                    fontSize: sizeScreen.width * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
              TransactionsBarChart(),
            ],
          ),
        ),
      ),
    );
  }
}
