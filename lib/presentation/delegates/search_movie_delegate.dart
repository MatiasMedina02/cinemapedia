import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        return _MovieItem(movie: _cachedMovies[index]);
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
            return _MovieItem(movie: movies[index]);
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;

  const _MovieItem({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => context.push('/movie/${movie.id}'),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath,
                  placeholder: (context, url) => SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyle.titleMedium,
                  ),
                  Text(
                    movie.releaseDate,
                    style: textStyle.titleMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half,
                        color: Colors.yellow.shade800,
                      ),
                      Text(
                        HumanFormats.number(movie.voteAverage),
                        style: textStyle.bodyMedium?.copyWith(
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
