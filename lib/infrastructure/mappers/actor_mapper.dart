import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_castdb.dart';

class ActorMapper {
  static Actor castToEntity(CastFromDb cast) => Actor(
      id: cast.id,
      name: cast.name,
      profilePath: cast.profilePath != null
          ? 'https://image.tmdb.org/t/p/original${cast.profilePath}'
          : 'https://static.vecteezy.com/system/resources/thumbnails/020/765/399/small_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg',
      character: cast.character);
}
