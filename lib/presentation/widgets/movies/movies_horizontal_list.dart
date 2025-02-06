import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

    return SizedBox(
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  return _Slide(movie: widget.movies[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatefulWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  State<_Slide> createState() => _SlideState();
}

class _SlideState extends State<_Slide> {
  bool isLoading = true;

  void disableSkeleton() {
    if (!mounted) return; // Evitar errores si el widget ya no está en pantalla
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: isLoading,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => context.push('/movie/${widget.movie.id}'),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 150,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    widget.movie.posterPath,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        Future.delayed(
                            Duration(seconds: 3), () => disableSkeleton());
                        return child;
                      }
                      return Container(
                        width: 150,
                        height: 200,
                        color: colors.primary,
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: 150,
                padding: EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: textStyle.titleSmall,
                      maxLines: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_half,
                          color: Colors.yellow.shade800,
                        ),
                        Text(
                          HumanFormats.number(widget.movie.voteAverage),
                          style: textStyle.bodyMedium?.copyWith(
                            color: Colors.yellow.shade800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
