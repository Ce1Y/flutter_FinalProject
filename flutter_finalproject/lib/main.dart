import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_finalproject/searchAnchor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_finalproject/character.dart';
import 'package:flutter_finalproject/characterTile.dart';
import 'package:flutter_finalproject/characterDetailTile.dart';
import 'package:flutter_finalproject/searchAnchor.dart';

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
      home: const MyHomePage(title: 'Jojo圖鑑'),
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
  String searchTerm = '';
  final SearchController controller = SearchController();

  @override
  initState() {
    super.initState();
    // FocusScope.of(context).requestFocus(null);
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
      // show success message
      Fluttertoast.showToast(
        msg: "success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12,
      );
      return characters;
    } else {
      // show failure message
      Fluttertoast.showToast(
        msg: "fail",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12,
      );
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchAnchorAsyncExampleApp(),
                                ),
                              );
                            },
                          ),
                          // Expanded(
                          //   child: Container(
                          //     height: 30,
                          //     child: SearchAnchor(
                          //       builder: (context, controller) {
                          //         return SearchBar(
                          //           leading: const Icon(Icons.search),
                          //           controller: controller,
                          //           hintText: 'Enter character name',
                          //           textInputAction: TextInputAction.search,
                          //           onSubmitted: (value) {
                          //             searchTerm = value;
                          //           },
                          //         );
                          //       },
                          //       // Show all of the suggestions containing input text
                          //       suggestionsBuilder:
                          //           (context, controller) async {
                          //         // Get all of the name contain search term
                          //         List<Character> characters = [];
                          //         for (var character
                          //             in await futureCharacters) {
                          //           if (character.name
                          //               .contains(controller.text)) {
                          //             characters.add(character);
                          //           }
                          //         }
                          //         // Return all of the suggestions
                          //         return List<ListTile>.generate(
                          //           characters.length,
                          //           (int index) {
                          //             final String name =
                          //                 characters[index].name;
                          //             return ListTile(
                          //               title: Text(name),
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         CharacterDetailTile(
                          //                             character:
                          //                                 characters[index]),
                          //                   ),
                          //                 );
                          //               },
                          //             );
                          //           },
                          //         );
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第一部–幻影血脈", style: TextStyle(fontSize: 20)),
                    ),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第二部–戰鬥潮流", style: TextStyle(fontSize: 20)),
                    ),
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
                                if (character.chapter
                                    .contains("Battle Tendency")) {
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
                    const SizedBox(height: 5),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第三部–星塵遠征軍", style: TextStyle(fontSize: 20)),
                    ),
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
                                if ((int.parse(character.id) >= 18 &&
                                        int.parse(character.id) <= 47) ||
                                    character.name == "Dio Brando") {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第四部–不滅鑽石", style: TextStyle(fontSize: 20)),
                    ),
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
                                // if (character.chapter
                                //     .contains('Diamond is Unbreakable')) {
                                if (int.parse(character.id) >= 48 &&
                                    int.parse(character.id) <= 74) {
                                  return CharacterTile(character: character);
                                }
                                // }
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第五部–黃金之風", style: TextStyle(fontSize: 20)),
                    ),
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
                                if (int.parse(character.id) >= 75 &&
                                    int.parse(character.id) <= 100) {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第六部–石之海", style: TextStyle(fontSize: 20)),
                    ),
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
                                if (int.parse(character.id) >= 101 &&
                                    int.parse(character.id) <= 122) {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第七部–飆馬野郎", style: TextStyle(fontSize: 20)),
                    ),
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
                                if (int.parse(character.id) >= 123 &&
                                    int.parse(character.id) <= 149) {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text("第八部–JoJo福音", style: TextStyle(fontSize: 20)),
                    ),
                    // "Jojolion" listView
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
                                if (int.parse(character.id) >= 150 &&
                                    int.parse(character.id) <= 175) {
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
