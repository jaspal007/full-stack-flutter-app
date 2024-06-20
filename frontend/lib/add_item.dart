import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo/global_variables.dart';
import 'package:http/http.dart' as http;

class MyItem extends StatefulWidget {
  final String id;
  final Function function;
  bool isUpdate;
  Map<String, dynamic> val = {};

  MyItem({
    super.key,
    required this.id,
    required this.function,
  }) : isUpdate = false;
  MyItem.update({
    super.key,
    required this.id,
    required this.function,
    required this.val,
  }) : isUpdate = true;

  @override
  State<MyItem> createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  get isUpdate => widget.isUpdate;
  get val => widget.val;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

  void onAdd() async {
    const String uri = storeTodo;
    var item = {
      "userId": widget.id,
      "title": (title.text.trim().isEmpty) ? 'Reminder' : title.text.trim(),
      "desc": (desc.text.trim().isEmpty) ? ' ' : desc.text.trim(),
    };

    var response;
    try {
      response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(item),
      );
    } catch (err) {
      print(err);
    }
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['msg']);
    ScaffoldMessenger.of(context).clearSnackBars();
    SnackBar snackBar = SnackBar(content: Text("${jsonResponse['msg']}"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    widget.function();
  }

  void updateItem(String id) async {
    final String uri = updateTodo + id;
    var item = {
      "userId": widget.id,
      "title": (title.text.trim().isEmpty) ? 'Reminder' : title.text.trim(),
      "desc": (desc.text.trim().isEmpty) ? ' ' : desc.text.trim(),
    };
    var response;
    try {
      response = await http.patch(Uri.parse(uri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(item));
    } catch (err) {
      print(err);
    }
    var jsonResponse = jsonDecode(response.body);
    SnackBar snackBar = SnackBar(content: Text('${jsonResponse['msg']}'));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
    widget.function();
  }

  @override
  void dispose() {
    super.dispose();
    title.dispose();
    desc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    title.value = TextEditingValue(text: (isUpdate) ? val['title'] : '');
    desc.value = TextEditingValue(text: (isUpdate) ? val['desc'] : '');
    return AlertDialog.adaptive(
      title: const Text('Add Item'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              controller: desc,
              decoration: const InputDecoration(
                label: Text('Description'),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            (isUpdate) ? updateItem(val['_id']) : onAdd();
          },
          child: Text((isUpdate) ? 'Update Item' : 'Add Item'),
        ),
      ],
    );
  }
}
