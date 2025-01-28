import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesBillboard extends StatelessWidget {
  final List<Movie> movies;

  const MoviesBillboard({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final DateTime dateToday = DateTime.now();

    return SizedBox(
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "On Billboard",
                  style: textStyle.titleLarge,
                ),
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  child: Text(
                    HumanFormats.date(dateToday),
                    style: textStyle.bodyMedium,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return _Slide(movie: movie);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 150,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Container(
                      width: 150,
                      color: Colors.grey.shade300,
                    );
                  }
                  return child;
                },
              ),
            ),
          ),

          // Title
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              style: textStyle.titleSmall,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),

          // Rating
          SizedBox(
            width: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
          )
        ],
      ),
    );
  }
}
