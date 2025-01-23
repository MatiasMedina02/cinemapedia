import 'movie_moviedb.dart';

class MoviedbResponse {
  final int page;
  final List<MovieFromMovieDb> results;
  final int totalPages;
  final int totalMovieFromMovieDbs;

  MoviedbResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalMovieFromMovieDbs,
  });

  factory MoviedbResponse.fromJson(Map<String, dynamic> json) =>
      MoviedbResponse(
        page: json["page"],
        results: List<MovieFromMovieDb>.from(
            json["results"].map((x) => MovieFromMovieDb.fromJson(x))),
        totalPages: json["total_pages"],
        totalMovieFromMovieDbs: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalMovieFromMovieDbs,
      };
}
