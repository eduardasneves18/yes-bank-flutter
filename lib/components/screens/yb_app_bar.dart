import 'package:flutter/material.dart';
import 'package:yes_bank/screens/signout/login/login.dart';
import '../yb_menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key}) : preferredSize = Size.fromHeight(70.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        'YesBank',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.yellow,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ],
    );
  }
}

class ComponenteGeral extends StatelessWidget {
  final Widget child;
  final Size sizeScreen;

  ComponenteGeral({required this.sizeScreen, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: Menu(),
      body: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B0B0B),
              Color(0xFF666666),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: sizeScreen.width * 0.05,
        ),
        width: sizeScreen.width,
        height: sizeScreen.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return ComponenteGeral(
      sizeScreen: sizeScreen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Nova transação',
              style: TextStyle(
                fontSize: sizeScreen.width * 0.05,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
