import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MoviesCarousel extends StatefulWidget {
  final List<Movie> movies;

  const MoviesCarousel({super.key, required this.movies});

  @override
  State<MoviesCarousel> createState() => _MoviesCarouselState();
}

class _MoviesCarouselState extends State<MoviesCarousel> {
  int currentMovie = 0;
  final CarouselSliderController controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      spacing: 10,
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            enlargeCenterPage: true,
            aspectRatio: 1.6,
            onPageChanged: (index, reason) {
              setState(() {
                currentMovie = index;
              });
            },
          ),
          itemCount: widget.movies.length,
          itemBuilder: (context, index, realIndex) {
            final movie = widget.movies[index];
            return _Slide(
              movie: movie,
              colors: colors,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
            (index) {
              return GestureDetector(
                onTap: () => controller.animateToPage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentMovie == index
                        ? colors.primary
                        : colors.inversePrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  final ColorScheme colors;

  const _Slide({required this.movie, required this.colors});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      boxShadow: [
        BoxShadow(
          color: colors.inversePrimary,
          blurRadius: 6.0,
          offset: Offset(0, 2),
          spreadRadius: 1.0,
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: movie.backdropPath,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
