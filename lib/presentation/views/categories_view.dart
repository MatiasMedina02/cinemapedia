import 'package:cinemapedia/domain/entities/genre.dart';
import 'package:cinemapedia/presentation/providers/movies/genres/movie_genres_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final movieGenres = ref.watch(movieGenresProvider);

    return SafeArea(
        child: movieGenres.when(
      error: (error, stackTrace) => Center(
        child: Icon(Icons.error),
      ),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
      data: (genres) {
        if (genres.isEmpty) {
          return const Center(child: Text("There Is No Genre Yet!"));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Categories", style: textStyle.headlineSmall),
              ),
              GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: genres.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _CategoryCard(genre: genres[index]);
                },
              ),
            ],
          ),
        );
      },
    ));
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.genre,
  });

  final Genre genre;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(genre.name),
    );
  }
}
