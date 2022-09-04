
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArchitectCharts extends StatefulWidget {
  const ArchitectCharts({Key key}) : super(key: key);

  @override
  State<ArchitectCharts> createState() => _ChartsState();
}

class _ChartsState extends State<ArchitectCharts> {
  List<SalesDetails> sales = [];

  FlutterSecureStorage storage = FlutterSecureStorage();
  // https://mongoapi3.herokuapp.com/experts
  Future<String> getJsonfromApi() async {
    String token = await storage.read(key: "token");
    String url='https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects/getUsersArchitectAppointmentsGraph';
    http.Response response=await http.get(Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },);
    return response.body;
  }

  Future loadSalesData() async{
    final String jsonString = await getJsonfromApi();
    final dynamic jsonResponse = json.decode(jsonString)['data'];
    print(jsonResponse);
    for (Map<String, dynamic> i in jsonResponse){
      sales.add(SalesDetails.fromJson(i));
    }
  }
  bool isLoading;
  void isLoading1() async{
    setState(() {
      isLoading=true;
    });

    await Future.delayed(
        Duration(seconds: 2));
    loadSalesData();
    setState(() {
      isLoading=false;
    });

  }
  TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    isLoading1();
    _tooltipBehavior =  TooltipBehavior(enable: true);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: isLoading==true?SizedBox(child: Center(
              child: CircularProgressIndicator(),
            ),):Container(
              child: FutureBuilder(
                  future:getJsonfromApi(),
                  // ignore: missing_return
                  builder: (context, snapshot){
                    //  List mydata = json.decode((snapshot.data.toString()));
                    if(snapshot.data==null){
                      return   Center(child: CircularProgressIndicator());
                    }else{
                      if (snapshot.hasData){
                        return (SfCartesianChart(
                            title: ChartTitle(text: 'Appointments According to days'),
                            tooltipBehavior: _tooltipBehavior,
                            primaryXAxis: CategoryAxis(),
                            legend: Legend(isVisible: true),
                            series: <ChartSeries>[
                              LineSeries<SalesDetails, String>(
                                dataSource: sales,
                                xValueMapper: (SalesDetails details, _) => details._id,
                                yValueMapper: (SalesDetails details, _) => details.NoOfAppontments,
                                dataLabelSettings:DataLabelSettings(isVisible : true),
                              )
                            ]
                        )
                        );
                      }
                      else{
                        Center(child: CircularProgressIndicator());
                      }
                    }

                  }
              ),
            )));
  }
}

class SalesDetails{
  SalesDetails(this._id , this.NoOfAppontments);
  final String _id;
  final int NoOfAppontments;

  factory SalesDetails.fromJson(Map<String, dynamic> parsedJson){
    return SalesDetails(parsedJson['_id']['truncatedOrderDate'].toString(), parsedJson['NoOfAppontments']
    );
  }
}
