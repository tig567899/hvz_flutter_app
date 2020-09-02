class Tag {
  String initiatorName;
  String initiatorRole;
  String receiverName;
  String receiverRole;
  int points;
  String location;
  String time;
  String tagType;

  Tag({
    this.initiatorName,
    this.initiatorRole,
    this.receiverName,
    this.receiverRole,
    this.points,
    this.location,
    this.time,
    this.tagType
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    initiatorName: json["initiator_name"],
    initiatorRole: json["initiator_role"],
    receiverName: json["receiver_name"],
    receiverRole: json["receiver_role"],
    points: json["points"],
    location: json["location"],
    time: json["time"],
    tagType: json["tag_type"],

  );

  Map<String, dynamic> toJson() => {
    "initiator_name": initiatorName,
    "initiator_role": initiatorRole,
    "receiver_name": receiverName,
    "receiver_role": receiverRole,
    "points": points,
    "location": location,
    "time": time,
    "tag_type": tagType,
  };
}