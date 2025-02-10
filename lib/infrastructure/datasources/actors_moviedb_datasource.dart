import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/helpers/dio.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';

class ActorsMoviedbDatasource extends ActorsDatasource {
  List<Actor> _jsonToActors(Map<String, dynamic> json) {
    final creditsDbResponse = CreditsResponse.fromJson(json);

    final List<Actor> actors = creditsDbResponse.cast
        .map((castDb) => ActorMapper.castToEntity(castDb))
        .toList();

    return actors;
  }

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToActors(response.data);
  }
}
