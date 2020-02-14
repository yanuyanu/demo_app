import 'package:flutter/material.dart';
import 'package:demo_app/model/movie_demo_ws.dart';
import 'package:demo_app/repository/movie_repository.dart';
import 'package:demo_app/common/session_enum.dart';
import 'package:demo_app/pages/menus/drawer_page.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Page',
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),drawer: DrawerPage(),
      body: FutureBuilder<String>(
              future: MovieRespository().getValue(SessionEnum.RECOMMENDED.toString()),
              builder: (BuildContext context, AsyncSnapshot<String> recommendedSnapshot){
                switch (recommendedSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (recommendedSnapshot.hasError) {
                          return Text('Error: ${recommendedSnapshot.error}');
                        } else {
                          if(recommendedSnapshot.data == 'true'){
                          return getTokenAndRecommendedMovie();
                          }
                          return Container();
                        }
                    }
              }),
    );
  }

  FutureBuilder getTokenAndRecommendedMovie(){
    return FutureBuilder<String>(
              future: MovieRespository().getValue(SessionEnum.TOKEN.toString()),
              builder: (BuildContext context, AsyncSnapshot<String> tokenSnapshot){
                switch (tokenSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        if (tokenSnapshot.hasError) {
                          return Text('Error: ${tokenSnapshot.error}');
                        } else {
                          return getMovieDetail(tokenSnapshot.data);
                        }
                    }
              });
  }

  FutureBuilder getMovieDetail(String token){

    return FutureBuilder(
        future: MovieRespository().findRecommended(token),
        builder: (context, projectSnap) {
          if(projectSnap.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator()
              );
          }
          if ((projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData)) {
            return Container();
          }
          MovieDemoWs movie = projectSnap.data;
          return Center(
        child: Scaffold(
                  body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: ListView(
              children: <Widget>[
                Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: NetworkImage(
                              movie.poster == 'N/A' ? 'https://www.archute.com/wp-content/themes/fox/images/placeholder.jpg' : movie.poster),
                        ),
                        ListTile(
                          leading: Icon(Icons.movie),
                          title: Text(movie.title),
                          subtitle: Text(movie.year),
                        ),
                      ],
                    ),
                  ),
                ),
                textFieldComponent(movie.label, 'Label'),
               textFieldComponent(movie.priority, 'Priority'),
                SwitchListTile(
                    title: Text('Viewed'),
                    value: movie.viewed,
                    onChanged: null
                    ),
                textFieldComponent(movie.rating, 'Rating'),
                textFieldComponent(DateTime.fromMillisecondsSinceEpoch(movie.timestamp * 1000).toString(), 'Timestamp'),
              ],
            ),
          ),
        ),
      );
        });
  }

  Widget textFieldComponent(String initialValue, String labelText){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.star),
        title: Text(labelText),
        subtitle: Text(initialValue),
      ),
    );
  }
}