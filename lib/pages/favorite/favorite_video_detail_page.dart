import 'package:flutter/material.dart';
import 'package:demo_app/model/movie_demo_ws.dart';
import 'package:demo_app/repository/movie_repository.dart';
import 'package:demo_app/common/session_enum.dart';

class FavoriteDetail extends StatelessWidget {
  final String imdbID;

  FavoriteDetail({Key key, @required this.imdbID}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FavoriteDetailPage(
        imdbID: imdbID,
      ),
    );
  }
}

class FavoriteDetailPage extends StatefulWidget {
  final String imdbID;

  FavoriteDetailPage({Key key, @required this.imdbID}) : super(key: key);

  @override
  _FavoriteDetailState createState() => _FavoriteDetailState();
}

class _FavoriteDetailState extends State<FavoriteDetailPage> {


  final labelController = TextEditingController();
  final priorityController = TextEditingController();
  final ratingController = TextEditingController();
  final timestampController = TextEditingController();

  bool _isViewed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
              future: MovieRespository().getValue(SessionEnum.TOKEN.toString()),
              builder: (BuildContext context, AsyncSnapshot<String> tokenSnapshot){
                switch (tokenSnapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (tokenSnapshot.hasError) {
                          return Text('Error: ${tokenSnapshot.error}');
                        } else {
                          return getMovieDetail(tokenSnapshot.data);
                        }
                    }
              }),
    );
  }

  FutureBuilder getMovieDetail(String token){

    return FutureBuilder(
        future: MovieRespository().findById(widget.imdbID, token),
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
          appBar: AppBar(
        title: Text('Movie Editor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
          onPressed: () {
            FocusScope.of(context).unfocus();
            savingProcess(movie, token);
          }),
          SizedBox(
            width: 30,
          ),
        ],
      ),
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
                textFieldComponent(movie.label, 'Label', labelController),
               textFieldComponent(movie.priority, 'Priority', priorityController),
                SwitchListTile(
                    title: Text('Viewed'),
                    value: movie.viewed,
                    onChanged: (bool value) {
                      _isViewed = value;
                    }),
                textFieldComponent(movie.rating == 'N/A' ? '0' : movie.rating, 'Rating', ratingController),
                textFieldComponent(DateTime.fromMillisecondsSinceEpoch(movie.timestamp * 1000).toString(), 'Timestamp', timestampController),
              ],
            ),
          ),
        ),
      );
        });
  }

  Widget textFieldComponent(String initialValue, String labelText, TextEditingController controller){
    controller.text = initialValue;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hoverColor: Colors.black,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blue[50],
          labelText: labelText,
        ),
      ),
    );
  }

  void savingProcess(MovieDemoWs movie, String token) async{
    MovieDemoWs newMovie = MovieDemoWs(
      imdbID: movie.imdbID,
      label: labelController.text,
      poster: movie.poster,
      priority: priorityController.text,
      rating: ratingController.text,
      timestamp: movie.timestamp,
      title: movie.title,
      year: movie.year,
      isExistingFavorite: movie.isExistingFavorite,
      viewed: _isViewed?? movie.viewed,
    );

    MovieRespository().saveOrUpdate(newMovie, token);
    final snackBar = SnackBar(
      content: Text('Save/Update Success and put to your Favorite'),
      duration: Duration(milliseconds: 1500),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();

  }
}
