import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

class MovieDbResponse {
  final Object dates;
  final int page;
  final List<MovieFromMovieDb> results;
  final int totalPages;
  final int totalResults;

  MovieDbResponse({
    required this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieDbResponse.fromJson(Map<String, dynamic> json) =>
      MovieDbResponse(
        dates: json["dates"],
        page: json["page"],
        results: List<MovieFromMovieDb>.from(
            json["results"].map((x) => MovieFromMovieDb.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "dates": dates,
        "page": page,
        "results": results,
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
