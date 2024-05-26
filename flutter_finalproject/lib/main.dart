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
      // disable swipe to navigate back
      body: PopScope(
        canPop: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple[100],
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // title
                    Container(
                      color: Colors.purple,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text("幻影血脈"),
                    // "phantom blood" listView
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
                              itemBuilder: (context, int index) {
                                var character = characters[index];
                                print(character.name);
                                if (int.parse(character.id) <= 9) {
                                  return CharacterTile(character: character);
                                } else {
                                  return null;
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
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("戰鬥潮流"),
                    // "Battle Tendency" listView
                    SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Character>>(
                        future: futureCharacters,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var characters = snapshot.data!;
                            int count = characters.length;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: count,
                              shrinkWrap: true,
                              itemBuilder: (context, int index) {
                                var character = characters[index];
                                print(index);
                                if (character.chapter
                                    .contains("Battle Tendency")) {
                                  return CharacterTile(character: character);
                                } else {
                                  print('do');
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
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("星辰遠征軍"),
                    // "Stardust Crusaders" listView
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
                                if (character.chapter
                                    .contains("Stardust Crusaders")) {
                                  return CharacterTile(character: character);
                                }
                                return Divider();
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("不滅鑽石"),
                    // "Diamond is Unbreakable" listView
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
                                if (character.chapter
                                    .contains('Diamond Is Unbreakable')) {
                                  return CharacterTile(character: character);
                                }
                                return null;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("黃金之風"),
                    // "Vento Aureo" listView
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
                                if (character.chapter.contains('Vento Aureo')) {
                                  return CharacterTile(character: character);
                                }
                                return null;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("石之海"),
                    // "Stone Ocean" listView
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
                                if (character.chapter.contains('Stone Ocean')) {
                                  return CharacterTile(character: character);
                                }
                                return null;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("飆馬野郎"),
                    // "Steel Ball Run" listView
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
                                if (character.chapter
                                    .contains('Steel Ball Run')) {
                                  return CharacterTile(character: character);
                                }
                                return null;
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Text("JoJo福音"),
                    // "Jojolion" listView
                    SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Character>>(
                        future: futureCharacters,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var characters = snapshot.data!;
                            print(characters.length);
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: characters.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var character = characters[index];
                                if (character.chapter.contains('Jojolion')) {
                                  return CharacterTile(character: character);
                                }
                                return null;
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
        ),
      ),
    );
  }
}
