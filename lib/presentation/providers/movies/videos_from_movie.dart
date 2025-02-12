import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final videoFromMovieProvider =
    StateNotifierProvider<VideoFromMovieMapNotifier, Map<int, Video>>((ref) {
  final getYoutubeVideos =
      ref.watch(movieRepositoryProvider).getYoutubeVideosById;

  return VideoFromMovieMapNotifier(getYoutubeVideos: getYoutubeVideos);
});

typedef GetVideoCallback = Future<List<Video>> Function(int movieId);

class VideoFromMovieMapNotifier extends StateNotifier<Map<int, Video>> {
  final GetVideoCallback getYoutubeVideos;

  VideoFromMovieMapNotifier({
    required this.getYoutubeVideos,
  }) : super({});

  Future<void> loadTrailer(int movieId) async {
    if (state[movieId] != null) return;

    final List<Video> videosFromMovie = await getYoutubeVideos(movieId);

    final Video? trailer = videosFromMovie
        .where((video) => video.type.toLowerCase() == "trailer")
        .firstOrNull;

    if (trailer != null) {
      state = {...state, movieId: trailer};
    }
  }
}
