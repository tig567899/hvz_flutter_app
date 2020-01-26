import 'dart:convert';

QueryResult queryFromJson(String str) => QueryResult.fromJson(json.decode(str));

String queryToJson(QueryResult data) => json.encode(data.toJson());

class QueryResult {
  int count;
  dynamic next;
  dynamic previous;
  List<PlayerInfo> results;

  QueryResult({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  factory QueryResult.fromJson(Map<String, dynamic> json) => QueryResult(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<PlayerInfo>.from(json["results"].map((x) => PlayerInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class PlayerInfo {
  String code;
  String roleChar;
  bool isOz;
  String name;
  String email;
  Faction faction;

  PlayerInfo({
    this.code,
    this.roleChar,
    this.isOz,
    this.name,
    this.email,
    this.faction,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => PlayerInfo(
    code: json["code"],
    roleChar: json["roleChar"],
    isOz: json["is_oz"],
    name: json["name"],
    email: json["email"],
    faction: Faction.fromJson(json["faction"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "roleChar": roleChar,
    "is_oz": isOz,
    "name": name,
    "email": email,
    "faction": faction.toJson(),
  };
}

class Faction {
  String name;
  String description;

  Faction({
    this.name,
    this.description,
  });

  factory Faction.fromJson(Map<String, dynamic> json) => Faction(
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
  };
}
