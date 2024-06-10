import 'package:flutter/material.dart';
import 'package:flutter_finalproject/stand.dart';
import 'package:flutter_finalproject/character.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class CharacterDetailTile extends StatefulWidget {
  const CharacterDetailTile({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  State<CharacterDetailTile> createState() => _CharacterDetailTile();
}

class _CharacterDetailTile extends State<CharacterDetailTile> {
  late Future<Stand> futureStand;
  late Image image;

  @override
  initState() {
    super.initState();
    // futureStand = fetchStand();
    image = Image(
        image: CachedNetworkImageProvider(
            'https://jojos-bizarre-api.netlify.app/assets/${widget.character.image}'));
  }

// Fetch stand json by api
  // Future<Stand> fetchStand() async {
  //   var response = await http.get(Uri.parse(
  //       'https://stand-by-me.herokuapp.com/api/v1/stands/query/query?standUser=${widget.character.id}'));
  //   if (response.statusCode == 200) {
  //     // TODO: handle type cast from List<dynamic> to Map<String, dynamic>
  //     return Stand.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   } else {
  //     throw Exception('Failed to load stand');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background color
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.purple[100],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // character image
                      SizedBox(
                        height: 300,
                        width: 150,
                        child: Align(
                          alignment: Alignment.center,
                          child: image,
                        ),
                      ),
                      // space between character's image and profile
                      const SizedBox(
                        width: 5,
                      ),
                      // character profile
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('姓氏：${widget.character.name}'),
                                Text('日本姓氏：${widget.character.japaneseName}'),
                                Text('能力：${widget.character.abilities}'),
                                Text('國籍：${widget.character.nationality}'),
                                Text('口號：${widget.character.catchphrase}'),
                                Text('出現章節：${widget.character.chapter}'),
                                Text('人類與否：${widget.character.isHuman}'),
                                Text('生死：${widget.character.living}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
