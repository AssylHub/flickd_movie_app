import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flickd_app/controllers/main_page_data_controller.dart';
import '../model/main_screen_data.dart';
import 'package:flickd_app/widgets/movie_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Models
import "../model/search_category.dart";
import '../model/movie.dart';

final mainScreenDataControllerProvider =
    StateNotifierProvider<MainScreenDataController, MainScreenData>((ref) {
  return MainScreenDataController();
});

final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final _movies = ref.watch(mainScreenDataControllerProvider).movies;
  return _movies.length != 0 ? _movies[0].posterURL() : null;
});

// final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
//   final _movies = ref.watch(mainScreenDataControllerProvider).movies!;
//   return _movies.length != 0 ? _movies[0].posterURL() : null;
// });

final class MainScreen extends ConsumerWidget {
  late double _deviceHeight;
  late double _deviceWidth;

  // late String _selectedMoviePosterURL;
  late dynamic _selectedMoviePosterURL;

  late MainScreenDataController _mainScreenDataController;
  late MainScreenData _mainScreenData;

  late TextEditingController? _searchTextFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainScreenDataController =
        ref.watch(mainScreenDataControllerProvider.notifier);
    _mainScreenData = ref.watch(mainScreenDataControllerProvider);
    _selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);

    _searchTextFieldController = TextEditingController();

    // _searchTextFieldController.text = _mainScreenData.searchCategory;
    _searchTextFieldController!.text = _mainScreenData.searchText!;

    return _buildUI(ref);
  }

  Widget _buildUI(WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Colors.blue,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgorundWidget(),
            _foregroundWidgets(ref),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     // padding: const EdgeInsets.only(top: 55, right: 50),
            //     child: const Banner(
            //       message: "DAULET",
            //       location: BannerLocation.topEnd,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _backgorundWidget() {
    if (_selectedMoviePosterURL != null) {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              image: CachedNetworkImageProvider(_selectedMoviePosterURL),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
          ),
        ),
      );
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.amber,
      );
    }
  }

  Widget _foregroundWidgets(WidgetRef ref) {
    return Container(
      // alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0, _deviceHeight * 0.02, 0, 0),
      width: _deviceWidth * 0.88,
      // decoration: BoxDecoration(color: Colors.amber),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight * 0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
            child: _moviesListViewWidget(ref),
          )
        ],
      ),
    );
  }

  Widget _topBarWidget() {
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

  Widget _searchFieldWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _deviceWidth * 0.5,
      height: _deviceHeight * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) =>
            _mainScreenDataController.updateTextSearch(_input),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white24,
          ),
          hintText: "Search..",
          hintStyle: TextStyle(
            color: Colors.white54,
          ),
          fillColor: Colors.white54,
          filled: false,
        ),
      ),
    );
  }

  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.none,
        ),
      ],
      onChanged: (dynamic _value) => _value.toString().isNotEmpty
          ? _mainScreenDataController.updateSearchCategory(_value)
          : null,
      value: _mainScreenData.searchCategory,
      icon: Badge(
        label: Text('+99'),
        child: Icon(
          Icons.menu,
          color: Colors.white24,
        ),
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
    );
  }

  Widget _moviesListViewWidget(WidgetRef ref) {
    final List<Movie> _movies = _mainScreenData.movies;

    // for (var i = 0; i < 20; i++) {
    //   _movies.add(Movie(
    //     name: "Star Wars",
    //     language: "en",
    //     isAdult: false,
    //     description:
    //         "Princess Leia is captured and held hostage by the evil Imperial forces in their effort to take over the galactic Empire. Venturesome Luke Skywalker and dashing captain Han Solo team together with the loveable robot duo R2-D2 and C-3PO to rescue the beautiful princess and restore peace and justice in the Empire.",
    //     posterPath: "/6FfCtAuVAW8XJjZ7eWeLibRLWTw.jpg",
    //     backdropPath: "/4qCqAdHcNKeAHcK8tJ8wNJZa9cx.jpg",
    //     rating: 8.204,
    //     releaseData: "1977-05-25",
    //   ));
    // }

    if (_movies.isNotEmpty) {
      return NotificationListener(
        onNotification: (_onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _mainScreenDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (_context, _count) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: _deviceHeight * 0.01),
              child: GestureDetector(
                onTap: () {
                  // _selectedMoviePosterURL = _movies[_count].posterURL();
                  ref.read(selectedMoviePosterURLProvider.notifier).state =
                      _movies[_count].posterURL();

                  print("Something");
                  //  _selectedMoviePosterURL.state = _movies[_count].posterURL();
                },
                child: MovieTile(
                    height: _deviceHeight * 0.2,
                    width: _deviceWidth * 0.85,
                    movie: _movies[_count]),
              ),
            );
          },
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    );
  }
}
