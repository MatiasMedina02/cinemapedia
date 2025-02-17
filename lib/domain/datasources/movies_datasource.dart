import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getSimilarMovies(int movieId);
  Future<Movie> getMovieById(int id);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Video>> getYoutubeVideosById(int movieId);
  Future<List<Genre>> getMovieGenres();
  Future<List<Movie>> filterByGenre(int genreId);
}
