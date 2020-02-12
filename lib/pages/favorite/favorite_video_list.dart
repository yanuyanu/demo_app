import 'package:demo_app/model/movie_demo_ws.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';
import 'package:demo_app/pages/favorite/favorite_video_detail_page.dart';
import 'package:demo_app/repository/movie_repository.dart';
import 'package:demo_app/common/session_enum.dart';

class FavoriteVideoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Page',
      home: FavoriteVideoListPage(),
    );
  }
}

class FavoriteVideoListPage extends StatefulWidget {
  @override
  _FavoriteVideoListPageState createState() => _FavoriteVideoListPageState();
}

class _FavoriteVideoListPageState extends State<FavoriteVideoListPage> {

  // void _searchMovie(String title, String year) {
  //   MovieRespository().findAllByTitleAndYear(title, year).then((val) => setState(() {
  //     _resultMovie = MovieRespository().findAllByTitleAndYear(title, year);
  //   }));
  // }

  Widget cardMovie(MovieDemoWs movie) {
    return Card(
        margin: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: <Widget>[
            Image(
              image: NetworkImage(movie.poster),
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
                  child: Icon(Icons.remove),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Favorite Movie'),
        ),
      drawer: DrawerPage(),
      body: FutureBuilder<String>(
          future: MovieRespository().getValue(SessionEnum.TOKEN.toString()),
          builder: (BuildContext context, AsyncSnapshot<String> tokenSnapshot) {
            switch (tokenSnapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              default:
                if (tokenSnapshot.hasError) {
                  return Text('Error: ${tokenSnapshot.error}');
                } else {
                  return getMovieList(tokenSnapshot.data);
                }
            }
          }),
    );
  }

  FutureBuilder getMovieList(String token) {
    return FutureBuilder(
        future: MovieRespository().findAllFavorite(token),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if ((projectSnap.connectionState == ConnectionState.none && !projectSnap.hasData)) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          return ListView.builder(
            itemCount: projectSnap.data.movies.length,
            itemBuilder: (context, index) {
              MovieDemoWs movies = projectSnap.data.movies[index];
              return cardMovie(movies);
            },
          );
        });
  }
}
