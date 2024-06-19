import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/dashboard.dart';
import 'package:todo/globalVariables.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isValid = true;
  late SharedPreferences pref;

  //methods
  @override
  void initState() {
    super.initState();
    initSharedPrefs();
  }

  void initSharedPrefs() async {
    pref = await SharedPreferences.getInstance();
    print('initialized');
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  void onSubmit() async {
    if (email.text.trim().isEmpty || !email.text.contains('@')) {
      setState(() {
        isValid = false;
      });
    } else {
      setState(() {
        isValid = true;
      });
    }

    var user = {
      "email": email.text.trim(),
      "password": password.text,
    };

    var response;
    try {
      response = await http.post(
        Uri.parse(login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
    } on http.ClientException catch (err) {
      print('the error is: ${err.message}');
      ScaffoldMessenger.of(context).clearSnackBars();
      final snackBar = SnackBar(
        content: Text(err.message),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    var jsonResponse = jsonDecode(response.body);
    print('response: ${jsonResponse['token']}');
    var userToken = jsonResponse['token'];
    pref.setString('token', userToken);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyDashboard(
          token: userToken,
        ),
      ),
    );
    // ScaffoldMessenger.of(context).clearSnackBars();
    // final snackBar = SnackBar(
    //   content: Text(jsonResponse['status']),
    //   duration: const Duration(seconds: 2),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'LogIn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.all(20)),
          TextField(
            controller: email,
            decoration: InputDecoration(
              errorText: (isValid) ? null : 'Enter correct email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: const Text('Email'),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          TextField(
            controller: password,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: const Text('password'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
