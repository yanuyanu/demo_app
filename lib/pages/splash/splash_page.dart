import 'package:flutter/material.dart';
import 'dart:async';
import 'package:demo_app/pages/login/login_page.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    new Timer(const Duration(seconds: 3), onClose);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Video App',
              style: TextStyle(height: 1, fontSize: 40),
            ),
            Image.network('https://www.eudeka.id/wp-content/uploads/2019/11/flutter-logo-square-700x700.png'),
          ],
        ),
      ),
    );
  }

  void onClose() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, animation, secondaryAnimation) => new Login(),
        transitionDuration: const Duration(seconds: 3),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        }));
  }
}
