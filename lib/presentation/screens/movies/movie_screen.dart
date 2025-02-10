import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_bymovie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/similar_movies_provider.dart.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_details_provider.dart';
import 'package:cinemapedia/presentation/widgets/actors/actors_by_movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/similar_movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final int movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieDetailsProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    ref.read(similarMoviesProvider.notifier).loadMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieDetailsProvider)[widget.movieId];

    return Scaffold(
      body: movie == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _MovieView(movie: movie),
    );
  }
}

class _MovieView extends StatelessWidget {
  const _MovieView({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textStyle = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _CustomAppBar(
            movie: movie,
            textStyle: textStyle,
            size: size,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(
                movie: movie,
                colors: colors,
                textStyle: textStyle,
              ),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends ConsumerWidget {
  const _CustomAppBar({
    required this.movie,
    required this.textStyle,
    required this.size,
  });

  final Movie movie;
  final TextTheme textStyle;
  final Size size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    return SliverAppBar(
      title: Text(
        movie.title,
        style: textStyle.titleLarge,
      ),
      centerTitle: true,
      expandedHeight: size.height * 0.7,
      actions: [
        IconButton(
          onPressed: () async {
            await ref
                .read(favoriteMoviesProvider.notifier)
                .toggleFavorite(movie);

            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite
                ? Icon(Icons.favorite, color: Colors.red)
                : Icon(Icons.favorite_border),
            error: (_, __) => throw UnimplementedError(),
            loading: () => CircularProgressIndicator(),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(children: [
          SizedBox.expand(
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox.expand(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.3, 0.7, 1.0]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final ColorScheme colors;
  final TextTheme textStyle;

  const _MovieDetails({
    required this.colors,
    required this.movie,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          FilledButton.icon(
            onPressed: () {},
            label: Text("Trailer"),
            icon: Icon(Icons.play_arrow),
          ),
          // Genres
          Wrap(
            spacing: 4.0,
            children: movie.genreIds.map(
              (genre) {
                return Chip(
                  label: Text(
                    genre,
                    style: textStyle.bodyMedium,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ).toList(),
          ),

          // Story Line
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              Text(
                "Story Line",
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                movie.overview,
                style: textStyle.bodyMedium,
              ),
            ],
          ),

          // Actors
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              Text(
                "Cast and Crew",
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ActorsByMovie(movieId: movie.id),
            ],
          ),

          // More Like This
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.0,
            children: [
              Text(
                "More Like This",
                style: textStyle.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SimilarMovies(movieId: movie.id),
            ],
          ),
        ],
      ),
    );
  }
}
