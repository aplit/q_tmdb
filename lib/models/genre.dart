class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  // Required fields
  int id;
  String name;

  Genre.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'gender': name,
      };
}
