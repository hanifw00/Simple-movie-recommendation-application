import '../config/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
 static Future<List<Movie>> getPopularMovies({required int page}) async {
  final idUrl =
      '${ApiConfig.baseUrl}/movie/popular'
      '?api_key=${ApiConfig.apiKey}'
      '&language=id-ID'
      '&page=$page';

  final enUrl =
      '${ApiConfig.baseUrl}/movie/popular'
      '?api_key=${ApiConfig.apiKey}'
      '&language=en-US'
      '&page=$page';

  final idResponse = await http.get(Uri.parse(idUrl));
  final enResponse = await http.get(Uri.parse(enUrl));

  if (idResponse.statusCode == 200 && enResponse.statusCode == 200) {
    final idResults = json.decode(idResponse.body)['results'] as List;
    final enResults = json.decode(enResponse.body)['results'] as List;

    final length =
        idResults.length < enResults.length
            ? idResults.length
            : enResults.length;

    return List.generate(length, (index) {
      return Movie.fromJson(
        idResults[index],
        enJson: enResults[index],
      );
    });
  } else {
    throw Exception('Gagal load movie');
  }
}

  
static Future<List<Movie>> searchMovies(String query) async {
  final url =
      '${ApiConfig.baseUrl}/search/movie'
      '?api_key=${ApiConfig.apiKey}'
      '&query=$query'
      '&language=en-US';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List results = data['results'];

    return results
        .map<Movie>((json) => Movie.fromSearchJson(json))
        .toList();
  } else {
    throw Exception('Gagal search movie');
  }
}


}