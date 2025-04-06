import 'package:dio/dio.dart';
import 'package:flickd_app/model/movie.dart';
import 'package:flickd_app/services/http_service.dart';
import 'package:get_it/get_it.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;

  late HTTPService _http;

  MovieService() {
    _http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({required int screen}) async {
    Response _response = await _http.get(path: "/movie/popular", query: {
      "screen": screen,
    });
    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    }
    throw Exception("Couldn't load popular movies.");
  }

  Future<List<Movie>> getUpcomingMovies({required int screen}) async {
    Response _response = await _http.get(path: "/movie/upcoming", query: {
      "screen": screen,
    });
    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    }
    throw Exception("Couldn't load upcoming movies.");
  }

  Future<List<Movie>> searchMovies(String _searchTerm, {int? screen}) async {
    Response _response = await _http.get(path: "/search/movie", query: {
      "query": _searchTerm,
      "screen": screen,
    });
    if (_response.statusCode == 200) {
      Map _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    }
    throw Exception("Couldn't perform movies search.");
  }
}
