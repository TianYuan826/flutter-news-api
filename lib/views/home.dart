import 'package:flutter/material.dart';
import 'package:flutter_news_api/helper/data.dart';
import 'package:flutter_news_api/helper/news.dart';
import 'package:flutter_news_api/models/article_model.dart';
import 'package:flutter_news_api/models/category_model.dart';
import 'package:flutter_news_api/views/article_list.dart';
import 'package:flutter_news_api/views/category_list.dart';
import 'package:flutter_news_api/views/note_list.dart';
import 'package:flutter_news_api/views/battery_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(

            backgroundColor: Colors.deepPurple,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => BatteryPage(),
              ));
            },
            child: Icon(Icons.battery_full),
          ),

          FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            // elevation: 20.0,
            onPressed: (){
              // print("Floating");
              Navigator.push(
                  context, MaterialPageRoute(
                      builder: (context) => NoteList()));
            },
            child: Icon(Icons.note_add),
            // child: new Text('Notes'),

          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('FlutterNews',
              style: TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  children: <Widget>[
                    /// Categories
                    CategoryList(
                      categories: categories,
                    ),

                    /// Blogs
                    ArticleList(
                      articles: articles,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
