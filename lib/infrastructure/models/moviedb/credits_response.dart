import 'package:cinemapedia/infrastructure/models/moviedb/credits_castdb.dart';

class CreditsResponse {
  final int id;
  final List<CastFromDb> cast;
  final List<CastFromDb> crew;

  CreditsResponse({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CreditsResponse.fromJson(Map<String, dynamic> json) =>
      CreditsResponse(
        id: json["id"],
        cast: List<CastFromDb>.from(
            json["cast"].map((x) => CastFromDb.fromJson(x))),
        crew: List<CastFromDb>.from(
            json["crew"].map((x) => CastFromDb.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}
