import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      height: 170,
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => context.push('/movie/${movie.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              width: size.width * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: movie.posterPath,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
              width: size.width * 0.6,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    movie.title,
                    style: textStyle.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: colors.outline,
                      ),
                      Text(
                        movie.releaseDate.split('-')[0],
                        style: textStyle.bodyLarge
                            ?.copyWith(color: colors.outline),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.local_movies,
                        color: colors.outline,
                      ),
                      Text(
                        "Movie",
                        style: textStyle.bodyLarge
                            ?.copyWith(color: colors.outline),
                      ),
                    ],
                  ),
                  if (!movie.adult)
                    Chip(
                      label: Text("PG-13"),
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
