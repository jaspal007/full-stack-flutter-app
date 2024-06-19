import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart' as jwt;

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

  @override
  void initState() {
    super.initState();
    final jwtDecoded = jwt.JwtDecoder.decode(token);

    email = jwtDecoded['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(email),
        centerTitle: true,
      ),
    );
  }
}
