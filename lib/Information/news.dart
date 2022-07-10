import 'package:blogapp/Information/weather.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_details.dart';
import 'newsinfo.dart';
import 'styles.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen> {
  final List<NewsDetail> items = [];

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text("Latest News", style: Styles.navBarTitle,),
          backgroundColor: Colors.lightGreen,
          actions: [
            IconButton(
                icon: Icon(FontAwesomeIcons.plus),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Weather(),
                      ));
                }),

          ],
        ),

        body: ListView.builder(
            itemCount: this.items.length,
            itemBuilder: _listViewItemBuilder
        )
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index){
    var newsDetail = this.items[index];
    return ListTile(
        contentPadding: EdgeInsets.all(10.0),
        leading: _itemThumbnail(newsDetail),
        title: _itemTitle(newsDetail),
        onTap: (){
          _navigationToNewsDetail(context, newsDetail);
        });
  }

  void _navigationToNewsDetail(BuildContext context, NewsDetail newsDetail){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context){return NewsInfo(newsDetail);}
        ));
  }

  Widget _itemThumbnail(NewsDetail newsDetail){
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: newsDetail.url == null ? null : Image.network(newsDetail.url, fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(NewsDetail newsDetail){
    return Text(newsDetail.title, style: Styles.textDefault);
  }

  void getNews() async{
    final http.Response response = await http.get("https://newsapi.org/v2/top-headlines?country=in&apiKey=d2eccaadb59e4fa0b3275a828607f722");
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['articles'].forEach((newsDetail) {
      final NewsDetail news = NewsDetail(
          description: newsDetail['description'],
          title: newsDetail['title'],
          url: newsDetail['urlToImage']
      );
      setState(() {
        items.add(news);
      });
    });
  }
}