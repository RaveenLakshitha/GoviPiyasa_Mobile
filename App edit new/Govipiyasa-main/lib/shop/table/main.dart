
import 'package:blogapp/shop/table/page/sortable_page.dart';
import 'package:blogapp/shop/table/widget/tabbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
        title: "Statistic",
        tabs: [
          Tab(icon: Icon(Icons.sort_by_alpha), text: 'Sortable'),
          Tab(icon: Icon(Icons.select_all), text: 'Selectable'),
          Tab(icon: Icon(Icons.edit), text: 'Editable'),
        ],
        children: [
          SortablePage(),
          Container(),
          Container(),
        ],
      );
}
