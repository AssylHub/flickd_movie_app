import 'package:flickd_app/model/main_screen_data.dart';
import 'package:flickd_app/model/movie.dart';
import 'package:flickd_app/model/search_category.dart';
import 'package:flickd_app/services/movie_service.dart';
import 'package:flickd_app/services/http_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '';

class MainScreenDataController extends StateNotifier<MainScreenData> {
  MainScreenDataController([MainScreenData? state])
      : super(state ?? MainScreenData.inital()) {
    getMovies();
  }

  final MovieService _movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    // try {
    List<Movie>? _movies = [];

    if (state.searchText.isEmpty) {
      if (state.searchCategory == SearchCategory.popular) {
        _movies = await _movieService.getPopularMovies(screen: state.screen);
      } else if (state.searchCategory == SearchCategory.upcoming) {
        _movies = await _movieService.getUpcomingMovies(screen: state.screen);
      } else if (state.searchCategory == SearchCategory.none) {
        _movies = [];
      }
    } else {
      // Perform text search

      _movies = await _movieService.searchMovies(state.searchText);
    }

    // _movies = await _movieService.getPopularMovies(screen: state.screen);
    state = state.copyWith(
      movies: [...state.movies, ..._movies],
      screen: state.screen,
    );
    // } catch (e) {}
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith(
        movies: [],
        screen: 1,
        searchCategory: _category,
        searchText: "",
      );
      getMovies();
    } catch (e) {}
  }

  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
        movies: [],
        screen: 1,
        searchCategory: SearchCategory.none,
        searchText: _searchText,
      );
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
