import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    super.initState();

    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider);

    if (favoriteMovies.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return SafeArea(
      child: ListView.builder(
          itemCount: favoriteMovies.length,
          itemBuilder: (context, index) {
            return MovieListItem(movie: favoriteMovies[index]);
          }),
    );
  }
}
