import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return localStorageRepository.isMovieFavorite(movieId);
});

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, List<Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return FavoriteMoviesNotifier(localStorageRepository: localStorageRepository);
});

class FavoriteMoviesNotifier extends StateNotifier<List<Movie>> {
  // int page = 0;
  final LocalStorageRepository localStorageRepository;

  FavoriteMoviesNotifier({
    required this.localStorageRepository,
  }) : super([]);

  Future<void> loadNextPage() async {
    final favoriteMovies = await localStorageRepository.loadFavoriteMovies();
    // page++;

    state = favoriteMovies;
  }
}
