import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_card.dart';
import 'package:flutter/material.dart';

class MoviesHorizontalList extends StatefulWidget {
  final List<Movie> movies;
  final String title;
  final String subTitle;
  final VoidCallback? loadNextPage;

  const MoviesHorizontalList({
    super.key,
    required this.movies,
    this.loadNextPage,
    required this.title,
    required this.subTitle,
  });

  @override
  State<MoviesHorizontalList> createState() => _MoviesHorizontalListState();
}

class _MoviesHorizontalListState extends State<MoviesHorizontalList> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
        // print(widget.movies.length);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.5,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: textStyle.titleLarge,
              ),
              if (widget.subTitle.isNotEmpty)
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                  child: Text(
                    widget.subTitle,
                    style: textStyle.bodyMedium,
                  ),
                )
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return MovieCard(movie: widget.movies[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
