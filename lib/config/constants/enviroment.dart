import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String movieDbKey =
      dotenv.env["THE_MOVIEDB_API_KEY"] ?? "No hay API Key";
}
