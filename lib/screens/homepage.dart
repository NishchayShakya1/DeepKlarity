import 'package:flutter/material.dart';
import 'package:project/screens/listpage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ListPage())),
            child: const Text(
              "Go to Second Page",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
