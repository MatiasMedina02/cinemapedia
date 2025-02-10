import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:dio/dio.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key': Enviroment.movieDbKey,
      // 'language': 'en-US',
    },
  ),
);
