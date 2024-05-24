import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? name;

  // initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (name != null) Text(name!),
            ElevatedButton(
              onPressed: () async {
                try {
                  var response = await http.get(Uri.parse(
                      'https://stand-by-me.herokuapp.com/api/v1/characters'));
                  if (response.statusCode == 200) {
                    print("success");
                    var characters = jsonDecode(response.body);
                    for (var character in characters) {
                      print(character);
                    }
                    setState(() {
                      name = characters[0]['name'];
                    });
                  } else {
                    print("fail");
                    setState(() {
                      name = 'error ${response.statusCode}';
                    });
                  }
                } catch (e) {
                  name = 'error $e';
                }
              },
              child: const Text("fetch data"),
            )
          ],
        ),
      ),
    );
  }
}
