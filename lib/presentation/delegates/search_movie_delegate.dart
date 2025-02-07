import 'dart:async';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_list_item.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  final StreamController<List<Movie>> debouncedMovies =
      StreamController.broadcast();
  final List<Movie> _cachedMovies = [];
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies});

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        debouncedMovies.add([]);
        return;
      }

      final movies = await searchMovies(query);
      _cachedMovies
        ..clear()
        ..addAll(movies);
      debouncedMovies.add(movies);
    });
  }

  @override
  String get searchFieldLabel => "Buscar película";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = "",
          icon: Icon(Icons.clear),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        debouncedMovies.close();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_cachedMovies.isEmpty) {
      return Center(
        child: Text("No se pudo encontrar la película"),
      );
    }

    return ListView.builder(
      itemCount: _cachedMovies.length,
      itemBuilder: (context, index) {
        return MovieListItem(movie: _cachedMovies[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);

    return StreamBuilder(
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieListItem(movie: movies[index]);
          },
        );
      },
    );
  }
}
