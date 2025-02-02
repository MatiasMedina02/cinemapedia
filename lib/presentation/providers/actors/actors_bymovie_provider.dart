import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorsByMovieProvider =
    StateNotifierProvider<ActorsMapNotifier, Map<String, List<Actor>>>((ref) {
  final getActors = ref.watch(actorsRepositoryProvider).getActorsByMovie;

  return ActorsMapNotifier(getActors: getActors);
});

typedef GetMovieCallback = Future<List<Actor>> Function(String movieId);

class ActorsMapNotifier extends StateNotifier<Map<String, List<Actor>>> {
  final GetMovieCallback getActors;

  ActorsMapNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
