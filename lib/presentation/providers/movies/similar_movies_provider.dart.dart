import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final similarMoviesProvider =
    StateNotifierProvider<SimilarMoviesMapNotifier, Map<int, List<Movie>>>(
        (ref) {
  final getSimilarMovies = ref.watch(movieRepositoryProvider).getSimilarMovies;

  return SimilarMoviesMapNotifier(getSimilarMovies: getSimilarMovies);
});

typedef GetMovieCallback = Future<List<Movie>> Function(int movieId);

class SimilarMoviesMapNotifier extends StateNotifier<Map<int, List<Movie>>> {
  final GetMovieCallback getSimilarMovies;

  SimilarMoviesMapNotifier({
    required this.getSimilarMovies,
  }) : super({});

  Future<void> loadMovies(int movieId) async {
    if (state[movieId] != null) return;

    final List<Movie> similarMovies = await getSimilarMovies(movieId);

    state = {...state, movieId: similarMovies};
  }
}
