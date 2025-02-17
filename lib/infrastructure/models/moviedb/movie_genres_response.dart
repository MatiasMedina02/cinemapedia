class MovieGenresResponse {
  final List<GenreFromDb> genres;

  MovieGenresResponse({
    required this.genres,
  });

  factory MovieGenresResponse.fromJson(Map<String, dynamic> json) =>
      MovieGenresResponse(
        genres: List<GenreFromDb>.from(
            json["genres"].map((x) => GenreFromDb.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}

class GenreFromDb {
  final int id;
  final String name;

  GenreFromDb({
    required this.id,
    required this.name,
  });

  factory GenreFromDb.fromJson(Map<String, dynamic> json) => GenreFromDb(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
