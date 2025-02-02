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
          Text(
            movie.title,
            style: textStyle.titleLarge,
          ),
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
          _ActorsByMovie(
            movieId: movie.id.toString(),
          ),
        ],
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Actor>? actorsByMovie =
        ref.watch(actorsByMovieProvider)[movieId];

    if (actorsByMovie == null) {
      return CircularProgressIndicator();
    }

    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: actorsByMovie.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final actor = actorsByMovie[index];

          return Container(
            width: 150,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    actor.profilePath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        width: 150,
                        height: 200,
                        color: Colors.grey.shade300,
                      );
                    },
                  ),
                ),
                Text(actor.name),
              ],
            ),
          );
        },
      ),
    );
  }
}
