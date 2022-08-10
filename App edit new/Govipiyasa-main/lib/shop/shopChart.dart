import 'package:blogapp/Architectureprofile/screens/product/components/body.dart';
import 'package:blogapp/shop/ShopProfile/Chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';


class Charts extends StatefulWidget {
  const Charts({Key key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  List<SalesDetails> sales = [];

  Future<String> getJsonFromAssets() async {
    return await rootBundle.loadString('assets/data.json');
  }

  Future loadSalesData() async{
    final String jsonString = await getJsonFromAssets();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse){
      sales.add(SalesDetails.fromJson(i));
    }
  }

  @override
  void initState() {
    loadSalesData();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      body: FutureBuilder(
        future: getJsonFromAssets(),
        // ignore: missing_return
        builder: (context, snapshot){
          if (snapshot.hasData){
            return (SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        LineSeries<SalesDetails, String>(
          dataSource: sales,
          xValueMapper: (SalesDetails details, _) => details.month,
          yValueMapper: (SalesDetails details, _) => details.SalesCount)
      ]
    )
    );
          }
          else{
            Center(child: CircularProgressIndicator());
          }
        }
      )));
  }
}

class SalesDetails{
  SalesDetails(this.month , this.SalesCount);
  final String month;
  final int SalesCount;

  factory SalesDetails.fromJson(Map<String, dynamic> parsedJson){
    return SalesDetails(
      parsedJson['month'].toString(), parsedJson['salesCount']
    );
  }
}
