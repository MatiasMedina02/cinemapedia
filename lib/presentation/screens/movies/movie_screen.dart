import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_bymovie_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;

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
          _CustomAppBar(movie: movie, textStyle: textStyle, size: size),
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

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    required this.movie,
    required this.textStyle,
    required this.size,
  });

  final Movie movie;
  final TextTheme textStyle;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        movie.title,
        style: textStyle.titleLarge,
      ),
      expandedHeight: size.height * 0.7,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          // Title
          Text(
            movie.title,
            style: textStyle.titleLarge,
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

          // Actors
          _ActorsByMovie(
            movieId: movie.id.toString(),
            textStyle: textStyle,
          ),

          // Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Description",
                style: textStyle.titleLarge,
              ),
              Text(
                movie.overview,
                style: textStyle.bodyMedium,
              ),
            ],

            // TODO: More Like This
          )
        ],
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  final TextTheme textStyle;

  const _ActorsByMovie({
    required this.movieId,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Actor>? actorsByMovie =
        ref.watch(actorsByMovieProvider)[movieId];

    if (actorsByMovie == null) {
      return Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: actorsByMovie.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final actor = actorsByMovie[index];

          return SizedBox(
            width: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(actor.profilePath,
                      height: 150, width: 100, fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return Container(
                        width: 150,
                        color: Colors.grey.shade300,
                      );
                    }
                    return child;
                  }),
                ),
                Text(
                  actor.name,
                  style: textStyle.bodySmall,
                ),
                Text(
                  actor.character ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
