import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_finalproject/character.dart';
import 'package:flutter_finalproject/characterTile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter final project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Jojo百科'),
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
  late Future<List<Character>> futureCharacters;
  bool isLoading = true;

  @override
  initState() {
    super.initState();
    futureCharacters = fetchCharacters();
  }

  // fetch jojo characters
  Future<List<Character>> fetchCharacters() async {
    var response = await http
        .get(Uri.parse('https://stand-by-me.herokuapp.com/api/v1/characters'));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Character> characters = List<Character>.from(jsonResponse.map(
        (i) => Character.fromJson(i),
      ));
      Fluttertoast.showToast(
        msg: "success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12,
      );
      setState(() {
        isLoading = false;
      });
      return characters;
    } else {
      Fluttertoast.showToast(
        msg: "fail",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // listView
                SizedBox(
                  height: 300,
                  child: FutureBuilder<List<Character>>(
                    future: futureCharacters,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var characters = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: characters.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var character = characters[index];
                            if (character.chapter.contains('Phantom Blood')) {
                              return CharacterTile(character: character);
                            } else {
                              return Divider();
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
