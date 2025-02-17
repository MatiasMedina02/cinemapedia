import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/helpers/dio.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_videos_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';

class MoviedbDatasource extends MoviesDatasource {
  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbResponse.results
        .where((movieDb) => movieDb.posterPath != 'no-poster')
        .map((movieDb) => MovieMapper.movieDbToEntity(movieDb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      "page": page,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {
      "page": page,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(int id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final movieDbResponse = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsToEntity(movieDbResponse);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    final response = await dio.get('/search/movie', queryParameters: {
      "query": query,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');

    if (response.statusCode != 200) {
      throw Exception('Movie videos with id: $movieId not found');
    }

    final movieDbResponse = MovieVideosResponse.fromJson(response.data);

    final List<Video> videos = movieDbResponse.results
        // .where((movieDb) => movieDb.posterPath != 'no-poster')
        .map((video) => MovieMapper.movieVideosToEntity(video))
        .toList();

    return videos;
  }

  // Genres
  @override
  Future<List<Genre>> getMovieGenres() async {
    final response = await dio.get('/genre/movie/list');

    if (response.statusCode != 200) {
      throw Exception('Movie Genres not found');
    }

    final movieDbResponse = MovieGenresResponse.fromJson(response.data);

    final List<Genre> genres = movieDbResponse.genres
        .map((genre) => MovieMapper.movieGenresToEntity(genre))
        .toList();

    return genres;
  }

  @override
  Future<List<Movie>> filterByGenre(int genreId) async {
    final response = await dio.get('/discover/movie', queryParameters: {
      "with_genres": genreId,
    });

    if (response.statusCode != 200) {
      throw Exception('Movie videos with genreId: $genreId not found');
    }

    return _jsonToMovies(response.data);
  }
}
