class Stand {
  final String id;
  final String name;
  final String alternateName;
  final String japaneseName;
  final String image;
  final String standUser;
  final String chapter;
  final String abilities;
  final String battlecry;

  Stand(
      {required this.id,
      required this.name,
      required this.alternateName,
      required this.japaneseName,
      required this.image,
      required this.standUser,
      required this.chapter,
      required this.abilities,
      required this.battlecry});

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      id: json['id'],
      name: json['name'],
      alternateName: json['alternateName'],
      japaneseName: json['japaneseName'],
      image: json['image'],
      standUser: json['standUser'],
      chapter: json['chapter'],
      abilities: json['abilities'],
      battlecry: json['battlecry'],
    );
  }
}
