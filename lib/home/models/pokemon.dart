// models/pokemon.dart

class Pokemon {
  int? id;

  final String name;
  final String url;
  String? imageUrl;

  bool isWishlisted;
  List<Stats>? stats;
  List<Ability>? abilities;
  int? weight;

  Pokemon({
    this.id,
    required this.name,
    required this.url,
    this.imageUrl,
    this.stats,
    this.abilities,
    this.weight,
    this.isWishlisted = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Stats {
  final int? baseStat;
  final String? stat;
  Stats({this.baseStat, this.stat});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      baseStat: json['base_stat'],
      stat: json['stat']['name'],
    );
  }
}

class Ability {
  String? ability;
  int? slot;
  bool? isHidden;

  Ability({this.ability, this.slot, this.isHidden});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: json['ability']['name'],
      slot: json['slot'],
      isHidden: json['is_hidden'],
    );
  }
}
