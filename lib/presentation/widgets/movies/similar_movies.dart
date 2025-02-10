import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/similar_movies_provider.dart.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimilarMovies extends ConsumerWidget {
  final int movieId;

  const SimilarMovies({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Movie>? similarMovies =
        ref.watch(similarMoviesProvider)[movieId];
    final size = MediaQuery.of(context).size;

    if (similarMovies == null) return Text("No Movies");

    return SizedBox(
      height: size.height * 0.45,
      child: ListView.builder(
        itemCount: similarMovies.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return MovieCard(movie: similarMovies[index]);
        },
      ),
    );
  }
}
