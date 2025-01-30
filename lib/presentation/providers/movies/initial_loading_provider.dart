import 'package:cinemapedia/presentation/providers/movies/movie_carousel_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final carouselMovies = ref.watch(moviesCarouselProvider);
  final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
  final upcomingMovies = ref.watch(upcomingMoviesProvider);

  if (carouselMovies.isEmpty ||
      nowPlayingMovies.isEmpty ||
      upcomingMovies.isEmpty) {
    return true;
  } else {
    return false;
  }
});
