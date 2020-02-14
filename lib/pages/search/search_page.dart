import 'package:flutter/material.dart';
import 'dart:async';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/pages/favorite/favorite_video_detail_page.dart';
import 'package:demo_app/model/movie_omdb.dart';
import 'package:demo_app/model/search.dart';
import 'package:demo_app/repository/movie_repository.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Page',
      home: SearchPageState(),
    );
  }
}

class SearchPageState extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageState> {
  final titleFilterTextField = TextEditingController();
  final yearFilterTextField = TextEditingController();
  Future<MovieOmdb> _resultMovie;

  @override
  void dispose() {
    titleFilterTextField.dispose();
    yearFilterTextField.dispose();
    super.dispose();
  }

  int _currentPage = 1;
  int _totalPage = 0;

  void _searchNextPage(String title, String year, int page, String totalResults) {
    if (_currentPage < _totalPage) {
      setState(() {
        _currentPage = _currentPage + 1;

        MovieRespository()
            .findAllByTitleAndYear(title, year, _currentPage)
            .then((val) => setState(() {
                  _resultMovie = MovieRespository()
                      .findAllByTitleAndYear(title, year, _currentPage);
                }));
      });
    }
  }

  void _searchPreviousPage(String title, String year, int page, String totalResults) {
    if (_currentPage > 1) {
      setState(() {
        _currentPage = _currentPage - 1;

        MovieRespository()
            .findAllByTitleAndYear(title, year, _currentPage)
            .then((val) => setState(() {
                  _resultMovie = MovieRespository()
                      .findAllByTitleAndYear(title, year, _currentPage);
                }));
      });
    }
  }

  int _calculateTotalPage(String totalPage){
    int total = int.parse(totalPage);
    if(total % 10 == 0){
      return (double.parse(totalPage)/10).round();
    }else if(total < 10){
      return 1;
    }else{
      return (double.parse(totalPage)/10).round()+1;
    }
  }

  void _searchMovie(String title, String year) {
    MovieRespository()
        .findAllByTitleAndYear(title, year, 1)
        .then((val) => setState(() {
          _currentPage = 1;
          _totalPage = _calculateTotalPage(val.totalResults);
          _resultMovie =
              MovieRespository().findAllByTitleAndYear(title, year, 1);
            }));
  }

  Expanded _buildFilterTextField(
      int flex, String hintText, TextEditingController textEditingController, TextInputType textInputType) {
    return Expanded(
      flex: flex,
      child: TextField(

        controller: textEditingController,
        keyboardType: textInputType,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: 5,
              left: 15,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black26)),
      ),
    );
  }

  Widget cardMovie(Search movie) {
    return Card(
        margin: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(movie.poster == 'N/A'
                  ? 'https://www.archute.com/wp-content/themes/fox/images/placeholder.jpg'
                  : movie.poster),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text(movie.title),
              subtitle: Text(movie.year),
            ),
            ButtonBar(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: movie.imdbID,
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteDetail(
                                imdbID: movie.imdbID,
                              )),
                    );
                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget cardMovieList(MovieOmdb movie) {
    return ListView.builder(
      itemCount: movie.search.length,
      itemBuilder: (context, index) {
        Search searchList = movie.search[index];
        return cardMovie(searchList);
      },
    );
  }

  Widget showPageInformation(MovieOmdb movieOmdb) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.navigate_before),
              onPressed: () {
                _searchPreviousPage(
                    titleFilterTextField.text,
                    yearFilterTextField.text,
                    _currentPage,
                    movieOmdb.totalResults);
              }),
          Center(
              child: Text(
            'All Data: ${movieOmdb.totalResults}, ' +
                'Total Page: $_totalPage, ' +
                'Current Page: $_currentPage',
            style: TextStyle(fontSize: 15, color: Colors.black),
          )),
          IconButton(
              icon: Icon(Icons.navigate_next),
              color: Colors.black,
              onPressed: () {
                _searchNextPage(
                    titleFilterTextField.text,
                    yearFilterTextField.text,
                    _currentPage,
                    movieOmdb.totalResults);
              }),
        ],
        backgroundColor: Colors.blue[50],
      ),
      body: cardMovieList(movieOmdb),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          title: Text('Search Movie'),
          bottom: PreferredSize(
              child: Container(
                padding:
                    EdgeInsets.only(left: 25, right: 15, bottom: 10, top: 10),
                height: 65,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      _buildFilterTextField(3, 'Title', titleFilterTextField, TextInputType.text),
                      SizedBox(
                        width: 5,
                      ),
                      _buildFilterTextField(1, 'YYYY', yearFilterTextField, TextInputType.datetime),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              _searchMovie(titleFilterTextField.text,
                                  yearFilterTextField.text);
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: const Size.fromHeight(40)),
        ),
      ),
      drawer: DrawerPage(),
      body: FutureBuilder(
          future: _resultMovie,
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if ((projectSnap.connectionState == ConnectionState.none &&
                    !projectSnap.hasData) ||
                (projectSnap.hasData && projectSnap.data.response == 'False')) {
              //print('project snapshot data is: ${projectSnap.data}');
              return Container(
                child: Center(
                  child: Text('no data found'),
                ),
              );
            }
            if (projectSnap.connectionState == ConnectionState.done) {
              MovieOmdb movie = projectSnap.data;
              return showPageInformation(movie);
            }

            return null;
          }),
    );
  }
}
