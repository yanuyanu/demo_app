import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_app/pages/home/home_page.dart';

class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  setToken(String token) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', token);
  }

  final tokenTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: TextField(
                controller: tokenTextField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none
                    ), 
                    hintText: 'Token',
                    filled: true,
                    fillColor: Colors.grey[300],
                    ),
              ),
            ),
            Container(
              width: 350,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                onPressed: () {
                  setToken(tokenTextField.text);
                  Navigator.of(context).pushReplacement(new PageRouteBuilder(
                      maintainState: true,
                      opaque: true,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          new Home(),
                      transitionDuration: const Duration(seconds: 2),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return child;
                      }));
                },
                child: Text('Login'),
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
