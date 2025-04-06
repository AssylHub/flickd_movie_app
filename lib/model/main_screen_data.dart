import 'package:flickd_app/model/search_category.dart';

import 'movie.dart';

class MainScreenData {
  final List<Movie> movies;
  final int screen;
  final String searchCategory;
  final String searchText;

  var length;

  MainScreenData({
    required this.movies,
    required this.screen,
    required this.searchCategory,
    required this.searchText,
  });

  MainScreenData.inital()
      : movies = [],
        screen = 1,
        searchCategory = SearchCategory.popular,
        searchText = '';

  MainScreenData copyWith(
      {List<Movie>? movies,
      int? screen,
      String? searchCategory,
      String? searchText}) {
    return MainScreenData(
        movies: movies ?? this.movies,
        screen: screen ?? this.screen,
        searchCategory: searchCategory ?? this.searchCategory,
        searchText: searchText ?? this.searchText);
  }

  // MainPageData copyWith(
  //     {List<Movie>? movies,
  //     int? page,
  //     String? searchCategory,
  //     String? searchText}) {
  //   return MainPageData(
  //       movies: movies ?? this.movies,
  //       page: page ?? this.page,
  //       searchCategory: searchCategory ?? this.searchCategory,
  //       searchText: searchText ?? this.searchText);
  // }
}
