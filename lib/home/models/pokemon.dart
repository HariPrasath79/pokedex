// models/pokemon.dart

import 'package:isar/isar.dart';

part 'pokemon.g.dart';

@collection
class Pokemon {
  Id id = Isar.autoIncrement;

  final String name;
  final String url;
  String? imageUrl;

  bool isWishlisted;
  List<Stats>? stats;
  List<Ability>? abilities;
  int? weight;

  Pokemon({
    required this.name,
    required this.url,
    this.imageUrl,
    this.stats,
    this.isWishlisted = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}

@embedded
class Stats {
  final int? baseStat;
  final String? stat;
  Stats({ this.baseStat,  this.stat});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      baseStat: json['base_stat'],
      stat: json['stat']['name'],
    );
  }
}

@embedded
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
