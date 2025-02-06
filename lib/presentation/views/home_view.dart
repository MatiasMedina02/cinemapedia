import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/presentation/providers/movies/initial_loading_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_carousel_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_carousel.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_horizontal_list.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return Center(child: CircularProgressIndicator());

    final carouselMovies = ref.watch(moviesCarouselProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    final DateTime dateToday = DateTime.now();

    return Column(
      children: [
        CustomAppBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MoviesCarousel(movies: carouselMovies),
                MoviesHorizontalList(
                  title: "On Billboard",
                  subTitle: HumanFormats.date(dateToday),
                  movies: nowPlayingMovies,
                  loadNextPage: () => ref
                      .read(nowPlayingMoviesProvider.notifier)
                      .loadNextPage(),
                ),
                MoviesHorizontalList(
                  title: "Coming Soon",
                  subTitle: "",
                  movies: upcomingMovies,
                  loadNextPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
