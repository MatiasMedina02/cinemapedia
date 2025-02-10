import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_bymovie_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActorsByMovie extends ConsumerWidget {
  final int movieId;

  const ActorsByMovie({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final List<Actor>? actorsByMovie =
        ref.watch(actorsByMovieProvider)[movieId];

    if (actorsByMovie == null) return Text("No Actors");

    return SizedBox(
      height: 275,
      child: ListView.builder(
        itemCount: actorsByMovie.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final actor = actorsByMovie[index];

          return Container(
            width: 125,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: SizedBox(
                    width: 125,
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: actor.profilePath,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
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
