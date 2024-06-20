import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:todo/add_item.dart';
import 'package:todo/global_variables.dart';
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
  late List list;
  bool isWaiting = true;
  @override
  void initState() {
    super.initState();
    jwtDecoded = JwtDecoder.decode(token);
    email = jwtDecoded['email'];
    getItems();
  }

  void getItems() async {
    String uri = getTodos + jwtDecoded['_id'];
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
      );
      var jsonResponse = jsonDecode(response.body);
      list = jsonResponse;
      setState(() {
        isWaiting = false;
      });
    } catch (err) {
      print(err);
    }
  }

  void logOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String uri = logout + email;
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

  void deleteItem(String id) async {
    final String uri = deleteTodo + id;
    var response;
    try {
      response = await http.delete(Uri.parse(uri));
    } catch (err) {
      print(err);
    }
    var jsonResponse = jsonDecode(response.body);
    SnackBar snackBar = SnackBar(content: Text('${jsonResponse['msg']}'));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    getItems();
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 100),
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: (isWaiting)
                ? const CircularProgressIndicator.adaptive()
                : ListView.builder(
                    itemBuilder: (context, id) {
                      return Slidable(
                        key: ValueKey(list[id]['_id']),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                deleteItem(list[id]['_id']);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete_sweep_outlined,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showDialog(
                                  context: context,
                                  builder: (context) => MyItem.update(
                                    id: jwtDecoded['_id'],
                                    function: getItems,
                                    val: list[id],
                                  ),
                                );
                              },
                              backgroundColor: Colors.blue,
                              icon: Icons.edit_note,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(list[id]['title']),
                          subtitle: Text(
                            list[id]['desc'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return MyItem(
                  id: jwtDecoded['_id'],
                  function: getItems,
                );
              });
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
