import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_finalproject/character.dart';

class CharacterTile extends StatelessWidget {
  const CharacterTile({super.key, required this.character});
  final Character character;
  // final colors = const [Colors.white];

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: colors[Random().nextInt(6)],
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      elevation: 5,
      child: Container(
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 200,
              child: Image.network(
                  'https://jojos-bizarre-api.netlify.app/assets/' +
                      character.image),
            ),
            Text(
              character.name.isEmpty ? "Not found`" : character.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
