import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebase.dart';
import '../../services/firebase/transactions/transactions_firebase.dart';

class TransactionsBarChart extends StatefulWidget {
  const TransactionsBarChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionsBarChartState();
}

class TransactionsBarChartState extends State<TransactionsBarChart> {
  final double width = 12;
  late List<BarChartGroupData> rawBarGroups = [];
  int touchedGroupIndex = -1;
  List<Map<String, dynamic>> transactions = [];
  double maxValor = 0;
  List<String> monthTitles = [];

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  Future<void> getTransactions() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      TransactionsFirebaseService().getTransactions(user.uid).then((fetchedTransactions) {
        List<Map<String, dynamic>> _transactions = fetchedTransactions.map((transaction) {
          double valor = (transaction['valor'] is double)
              ? transaction['valor']
              : double.tryParse(transaction['valor'].toString()) ?? 0.0;

          DateFormat dateFormat = DateFormat('dd/MM/yyyy');
          DateTime transactionDate = dateFormat.parse(transaction['data']);

          return {
            'data': transactionDate,
            'valor': valor,
          };
        }).toList();

        transactions = _aggregateTransactionsByMonth(_transactions);
        print("Aggregated transactions by month: $transactions");
        findMaxValor();

        updateMonthTitles();

        rawBarGroups = transactions.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> transaction = entry.value;
          DateTime date = transaction['data'];
          double value = transaction['valor'];

          return makeGroupData(index, value, value);
        }).toList();

        setState(() {});

      }).catchError((error) {
        print('Error fetching transactions: $error');
      });
    }
  }

  void updateMonthTitles() {
    monthTitles.clear();
    Set<int> monthsSet = {};

    for (var transaction in transactions) {
      int month = transaction['data'].month;
      if (!monthsSet.contains(month)) {
        monthsSet.add(month);
        String monthName = DateFormat('MMM').format(transaction['data']);
        monthTitles.add(monthName);
      }
    }
  }

  List<Map<String, dynamic>> _aggregateTransactionsByMonth(List<Map<String, dynamic>> transactions) {
    Map<String, double> monthAggregatedValues = {};

    for (var transaction in transactions) {
      int month = transaction['data'].month;
      int year = transaction['data'].year;

      String monthKey = "$year-${month.toString().padLeft(2, '0')}";

      if (monthAggregatedValues.containsKey(monthKey)) {
        monthAggregatedValues[monthKey] = monthAggregatedValues[monthKey]! + transaction['valor'];
      } else {
        monthAggregatedValues[monthKey] = transaction['valor'];
      }
    }

    List<Map<String, dynamic>> aggregatedTransactions = monthAggregatedValues.entries.map((entry) {
      List<String> dateParts = entry.key.split('-');
      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);

      return {
        'data': DateTime(year, month, 1),
        'valor': entry.value,
      };
    }).toList();

    return aggregatedTransactions;
  }

  void findMaxValor() {
    if (transactions.isNotEmpty) {
      maxValor = transactions
          .map((transaction) => transaction['valor'])
          .reduce((a, b) => a > b ? a : b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 38),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxValor,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.green;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          return;
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                        interval: 3,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 80,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: rawBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(value.round().toString(), style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {

    final Widget text = Text(
      monthTitles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    );

    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
          width: width,
        ),
      ],
    );
  }
}
