import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:cinemapedia/presentation/views/categories_view.dart';
import 'package:cinemapedia/presentation/views/favorites_view.dart';
import 'package:cinemapedia/presentation/views/home_view.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(childView: child);
      },
      routes: [
        GoRoute(
            path: '/',
            builder: (context, state) {
              return HomeView();
            },
            routes: [
              GoRoute(
                path: 'movie/:id',
                builder: (context, state) {
                  final movieId = state.pathParameters['id'] ?? 'not-found';

                  return MovieScreen(movieId: movieId);
                },
              )
            ]),
        GoRoute(
          path: '/categories',
          builder: (context, state) {
            return CategoriesView();
          },
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return FavoritesView();
          },
        ),
      ],
    ),

    // Rutas padre / hijo
    // GoRoute(
    //     path: '/',
    //     builder: (context, state) => HomeScreen(
    //           childView: HomeView(),
    //         ),
    //     routes: [
    //       GoRoute(
    //         path: 'movie/:id',
    //         builder: (context, state) {
    //           final movieId = state.pathParameters['id'] ?? 'not-found';

    //           return MovieScreen(movieId: movieId);
    //         },
    //       )
    //     ]),
  ],
);
