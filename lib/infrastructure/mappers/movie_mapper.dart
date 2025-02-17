import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_genres_response.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_videos_response.dart';

class MovieMapper {
  static Movie movieDbToEntity(MovieFromMovieDb movieDb) => Movie(
        adult: movieDb.adult,
        backdropPath: movieDb.backdropPath != ""
            ? 'https://image.tmdb.org/t/p/original${movieDb.backdropPath}'
            : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png',
        genreIds: movieDb.genreIds.map((e) => e.toString()).toList(),
        id: movieDb.id,
        originalLanguage: movieDb.originalLanguage,
        originalTitle: movieDb.originalTitle,
        overview: movieDb.overview,
        popularity: movieDb.popularity,
        posterPath: movieDb.posterPath != ""
            ? 'https://image.tmdb.org/t/p/original${movieDb.posterPath}'
            : 'no-poster',
        releaseDate: movieDb.releaseDate,
        title: movieDb.title,
        video: movieDb.video,
        voteAverage: movieDb.voteAverage,
        voteCount: movieDb.voteCount,
      );

  static Movie movieDetailsToEntity(MovieDetails movieDb) => Movie(
        adult: movieDb.adult,
        backdropPath: movieDb.backdropPath != ""
            ? 'https://image.tmdb.org/t/p/original${movieDb.backdropPath}'
            : 'https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png',
        genreIds: movieDb.genres.map((e) => e.name).toList(),
        id: movieDb.id,
        originalLanguage: movieDb.originalLanguage,
        originalTitle: movieDb.originalTitle,
        overview: movieDb.overview,
        popularity: movieDb.popularity,
        posterPath: movieDb.posterPath != ""
            ? 'https://image.tmdb.org/t/p/original${movieDb.posterPath}'
            : 'no-poster',
        releaseDate: movieDb.releaseDate,
        title: movieDb.title,
        video: movieDb.video,
        voteAverage: movieDb.voteAverage,
        voteCount: movieDb.voteCount,
      );

  static Video movieVideosToEntity(VideoFromDb movieDb) => Video(
        id: movieDb.id,
        name: movieDb.name,
        site: movieDb.site,
        type: movieDb.type,
        youtubeKey: movieDb.key,
        publishedAt: movieDb.publishedAt,
      );

  static Genre movieGenresToEntity(GenreFromDb genreDb) => Genre(
        id: genreDb.id,
        name: genreDb.name,
      );
}
