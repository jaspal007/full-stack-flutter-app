import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo/globalVariables.dart';
import 'package:todo/login.dart';

class MyDashboard extends StatefulWidget {
  final String token;
  const MyDashboard({
    super.key,
    required this.token,
  });

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  get token => widget.token;
  late String email;
  late Map<String, dynamic> jwtDecoded;
  @override
  void initState() {
    super.initState();
    jwtDecoded = JwtDecoder.decode(token);
    email = jwtDecoded['email'];
  }

  void logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String uri = url + email;
    var response;
    try {
      response = await http.post(Uri.parse(uri));
    } catch (err) {
      print(err);
    }
    var jsonResponse = jsonDecode(response.body);
    print('response: ${jsonResponse['msg']}');
    await pref.setString('token', jsonResponse['token']);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyLogin(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog.adaptive(
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  title: const Text(
                    textAlign: TextAlign.center,
                    "Are you sure?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: const Text('This action can\'t be undone'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: logOut,
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                            color: Colors.red.shade900,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              'LOGOUT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
          ),
        ],
        title: Text(email),
        centerTitle: true,
      ),
    );
  }
}
