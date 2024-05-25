class Character {
  final String id;
  final String name;
  final String japaneseName;
  final String image;
  final String abilities;
  final String nationality;
  final String catchphrase;
  final String family;
  final String chapter;
  final bool living;
  final bool isHuman;

  Character(
      {required this.id,
      required this.name,
      required this.japaneseName,
      required this.image,
      required this.abilities,
      required this.nationality,
      required this.catchphrase,
      required this.family,
      required this.chapter,
      required this.living,
      required this.isHuman});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      japaneseName: json['japaneseName'],
      image: json['image'],
      abilities: json['abilities'],
      nationality: json['nationality'],
      catchphrase: json['catchphrase'],
      family: json['family'],
      chapter: json['chapter'],
      living: json['living'],
      isHuman: json['isHuman'],
    );
  }
}
