import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowPlaying({int page = 1});
  Future<List<Movie>> getUpcoming({int page = 1});
  Future<List<Movie>> getSimilarMovies(int movieId);
  Future<Movie> getMovieById(int id);
  Future<List<Movie>> searchMovies(String query);
  Future<List<Video>> getYoutubeVideosById(int movieId);
}
