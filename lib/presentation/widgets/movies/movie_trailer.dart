import 'package:cinemapedia/domain/entities/video.dart';
import 'package:cinemapedia/presentation/providers/movies/videos_from_movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailer extends ConsumerWidget {
  final int movieId;

  const MovieTrailer({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Video? trailer = ref.watch(videoFromMovieProvider)[movieId];

    if (trailer == null) return Placeholder();

    return _YoutubeVideoPlayer(youtubeId: trailer.youtubeKey);
  }
}

class _YoutubeVideoPlayer extends StatefulWidget {
  final String youtubeId;

  const _YoutubeVideoPlayer({
    required this.youtubeId,
  });

  @override
  State<_YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<_YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        mute: false,
        autoPlay: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Expanded(
        child: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
