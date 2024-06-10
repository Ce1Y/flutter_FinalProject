import 'package:flutter/material.dart';
import 'package:flutter_finalproject/character.dart';
import 'package:flutter_finalproject/characterDetailTile.dart';

/// Flutter code sample for [SearchAnchor].

const Duration fakeAPIDuration = Duration(seconds: 1);

class AsyncSearchAnchor extends StatefulWidget {
  const AsyncSearchAnchor({super.key, required this.futureCharacters});

  final Future<List<Character>> futureCharacters;

  @override
  State<AsyncSearchAnchor> createState() => _AsyncSearchAnchorState();
}

class _AsyncSearchAnchorState extends State<AsyncSearchAnchor> {
  String? _searchingWithQuery;
  late List<Character> _futureCharacters;
  List<Character> _suggestionCharacters = [];

  @override
  initState() {
    super.initState();
    getCharacterList();
  }

  void getCharacterList() async {
    _futureCharacters = await convertListType();
  }

  // Convert future type list to common list
  Future<List<Character>> convertListType() {
    return widget.futureCharacters;
  }

  void fetchSuggestionsList(String keyword) {
    _suggestionCharacters.clear();
    if (keyword != "") {
      for (var character in _futureCharacters) {
        if (character.name.toLowerCase().contains(keyword.toLowerCase())) {
          _suggestionCharacters.add(character);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SearchAnchor(
                builder: (BuildContext context, SearchController controller) {
                  // Search bar
                  return SearchBar(
                    // navigate back button
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        // Hint: if this widget return another materialApp, it'll return a black screen.
                        Navigator.pop(context);
                      },
                    ),
                    controller: controller,
                    hintText: 'Search character',
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    onChanged: (value) => {
                      setState(() {
                        fetchSuggestionsList(value);
                      }),
                    },
                    elevation: MaterialStateProperty.all(0),
                    autoFocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      bool isExist = false;
                      late Character navigateCharacter;
                      for (var character in _futureCharacters) {
                        if (character.name.toLowerCase() ==
                            value.toLowerCase()) {
                          isExist = true;
                          navigateCharacter = character;
                          break;
                        }
                      }
                      if (isExist) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailTile(
                                character: navigateCharacter),
                          ),
                        );
                      }
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) async {
                  return [];
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _suggestionCharacters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_suggestionCharacters[index].name),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CharacterDetailTile(
                                character: _suggestionCharacters[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
