import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/dashboard.dart';
import 'package:todo/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(token: pref.getString('token')));
}

class MyApp extends StatefulWidget {
  final token;
  const MyApp({
    super.key,
    @required this.token,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get token => widget.token;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: (JwtDecoder.isExpired(token) == true)
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('ToDo APP'),
                  centerTitle: true,
                ),
                body: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     MySignUp()
                  ],
                ),
              )
            : MyDashboard(token: token),
      ),
    );
  }
}
