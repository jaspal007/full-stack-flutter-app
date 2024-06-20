import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/globalVariables.dart';
import 'package:todo/login.dart';

// ignore: must_be_immutable
class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isValid = true;
  bool isHidden = true;

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
        Uri.parse(register),
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
    print('response: ${jsonResponse['success']}');
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      content: Text(jsonResponse['success']),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
    return Center(
      child: Column(
        children: [
          const Text(
            'SignUp',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const Padding(padding: EdgeInsets.all(20)),
          TextField(
            controller: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorText: (!isValid) ? 'Enter the correct email' : null,
              label: const Text('Email'),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          TextField(
            obscureText: isHidden,
            controller: password,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon((isHidden) ? Icons.lock : Icons.lock_open),
                onPressed: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
              ),
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
            child: const Text('Register'),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
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
            },
            child: const Text('Alerady an account? Login'),
          ),
        ],
      ),
    );
  }
}
