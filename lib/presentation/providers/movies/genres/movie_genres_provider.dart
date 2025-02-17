import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieGenresProvider = FutureProvider<List<Genre>>(
  (ref) {
    final movieRepository = ref.watch(movieRepositoryProvider);
    return movieRepository.getMovieGenres();
  },
);
