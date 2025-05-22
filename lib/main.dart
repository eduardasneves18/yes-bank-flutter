import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yes_bank/screens/signout/login/login.dart';
import 'package:yes_bank/store/cliente_store.dart';
import 'dart:async';
import 'screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runZoned<Future<void>>(() async {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => YesBankApp(),
      ),
    );
  });
}

class YesBankApp extends StatelessWidget {
  final materialTheme = ThemeData(
    primaryColor: Colors.black,
    hintColor: Colors.black,
    colorScheme: ColorScheme.light(
      primary: Colors.black, // primaryColor
      secondary: Colors.black, // accentColor
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClienteStore>(
          create: (_) => ClienteStore(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,  // Set the global navigator key
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Yes Bank',
        theme: materialTheme,
        home: HomeScreen(),
        initialRoute: 'home',
        routes: {
          'home': (context) => HomeScreen(),
          'login': (context) => Login(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('pt')],
      ),
    );
  }
}
