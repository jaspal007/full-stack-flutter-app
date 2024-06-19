import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/dashboard.dart';
import 'package:todo/login.dart';
import 'package:todo/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  runApp(MyApp(token: pref.getString('token')));
}

int id = 0;
List<Widget> list = [
  MySignUp(index: id),
  const MyLogin(),
];

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
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    list[id],
                    const Padding(padding: EdgeInsets.all(20)),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      label: 'Sign Up',
                      icon: IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          setState(() {
                            id = 0;
                          });
                        },
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: 'Log In',
                      icon: IconButton(
                        icon: const Icon(Icons.account_box),
                        onPressed: () {
                          setState(() {
                            id = 1;
                          });
                        },
                      ),
                    ),
                  ],
                  currentIndex: id,
                ),
              )
            : MyDashboard(token: token),
      ),
    );
  }
}
