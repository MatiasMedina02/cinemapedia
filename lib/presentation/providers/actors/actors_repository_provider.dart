import 'package:cinemapedia/infrastructure/datasources/actors_moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Es inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorsRepositoryImpl(datasource: ActorsMoviedbDatasource());
});
