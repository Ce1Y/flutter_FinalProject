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
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _searchingWithQuery;
  late List<Character> _futureCharacters;
  List<Character> _suggestionCharacters = [];

  // The most recent options received from the API.
  late Iterable<Widget> _lastOptions = <Widget>[];

  @override
  initState() {
    super.initState();
    getCharacterList();
  }

  // Convert future type list to common list
  Future<List<Character>> convertListType() {
    return widget.futureCharacters;
  }

  void getCharacterList() async {
    _futureCharacters = await convertListType();
  }

  void fetchSuggestionsList(String keyword) {
    _suggestionCharacters.clear();
    for (var character in _futureCharacters) {
      if (character.name.toLowerCase().contains(keyword.toLowerCase())) {
        _suggestionCharacters.add(character);
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
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        // If this widget return another materialApp, it'll return a black screen.
                        Navigator.pop(context);
                      },
                    ),
                    controller: controller,
                    hintText: 'Search character',
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                    // onChanged: (value) => {controller.openView()},
                    onChanged: (value) => {
                      setState(() {
                        fetchSuggestionsList(value);
                      }),
                    },
                    elevation: MaterialStateProperty.all(0),
                    autoFocus: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      // print(value);
                      bool isExist = false;
                      late Character navigateCharacter;
                      for (var character in _futureCharacters) {
                        // if (character.name.contains(value)) {
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
                      // setState(() {});
                    },
                  );
                },
                suggestionsBuilder:
                    (BuildContext context, SearchController controller) async {
                  print(controller.text);
                  _searchingWithQuery = controller.text;
                  final List<String> options =
                      (await _FakeAPI.search(_searchingWithQuery!)).toList();

                  // If another search happened after this one, throw away these options.
                  // Use the previous options instead and wait for the newer request to
                  // finish.
                  if (_searchingWithQuery != controller.text) {
                    return _lastOptions;
                  }

                  _lastOptions = List<ListTile>.generate(
                    options.length,
                    (int index) {
                      final String item = options[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          print("tapped");
                        },
                      );
                    },
                  );

                  return _lastOptions;
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

// Mimics a remote API.
class _FakeAPI {
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  // Searches the options, but injects a fake "network" delay.
  static Future<Iterable<String>> search(String query) async {
    await Future<void>.delayed(fakeAPIDuration); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return _kOptions.where((String option) {
      return option.contains(query.toLowerCase());
    });
  }
}
