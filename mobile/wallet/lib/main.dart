import 'package:flutter/material.dart';
import 'package:wallet/screens/authentication/login.dart';
import 'package:wallet/screens/wrapper.dart';
import 'package:wallet/screens/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypto Wallet",
      home: LoginPage(),
      theme: ThemeData(
        fontFamily: 'Ubuntu',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(primary: Colors.blueAccent),
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
