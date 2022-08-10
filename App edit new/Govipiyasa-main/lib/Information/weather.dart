
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class Weather extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _HomeState();
  }


}
class _HomeState extends State<Weather>{

  static const Citylist=[
    "Jaela",
    "Colombo",
    "Matara",
    "Galle",
    "Gampaha",
    "Balangoda",
    "Kaluthara",
    "Ambilipitiya"
  ];
  final _formkey=GlobalKey<FormState>();

  //http://api.openweathermap.org/data/2.5/weather?q=Ja-ela&appid=717bc49fc1d9c03e85f08c1e362c2bf3
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  TextEditingController _textEditingController = TextEditingController();
  Future getWeather(String city) async{

    http.Response response=await http.get("https://api.openweathermap.org/data/2.5/weather?q=$city&appid=717bc49fc1d9c03e85f08c1e362c2bf3");
    var results=jsonDecode(response.body);
    setState(() {
      this.temp=results['main']['temp'];
      this.description=results['weather'][0]['description'];
      this.currently=results['weather'][0]['main'];
      this.humidity=results['main']['humidity'];
      this.windSpeed=results['wind']['speed'];
    });
  }
  @override
  void initState(){
    super.initState();
    getWeather(_textEditingController.text);

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        // The search area here
          backgroundColor: Colors.lightGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(

              child:Form(
                key:_formkey,
                child: TypeAheadFormField(

                    suggestionsCallback: (pattern)=>Citylist.where((item)=>item.toLowerCase().contains(pattern.toLowerCase())
                    ),
                    itemBuilder: (_, String item)=>ListTile(title:Text(item)),
                  onSuggestionSelected: (String val){
                      this._textEditingController.text=val;
                      print(val);
                  },
                  getImmediateSuggestions: true,
                  hideSuggestionsOnKeyboardHide: false,
                  hideOnEmpty: false,
                  noItemsFoundBuilder: (context)=>Padding(
                    padding:const EdgeInsets.all(8.0),
                    child:Text('No item found'),
                  ),
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._textEditingController,
                    decoration: InputDecoration(
                        prefixIcon:IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            getWeather(_textEditingController.text);
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _textEditingController.clear();
                          },
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none),
                  ),

                ),
              )

            ),
          )),
      body: Column(
          children: <Widget>[
            Container(
              height:MediaQuery.of(context).size.height/3,
              width:MediaQuery.of(context).size.width,
              color:Colors.lightGreen,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(bottom: 10.0),
                    child:Text(
                      "Currently in ${_textEditingController.text}",
                      style:TextStyle(
                          color:Colors.white,
                          fontSize:14.0,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                  ),
                  Text(
                    temp!=null? temp.toString()+"52\u0000":"Loading",
                    style:TextStyle(
                        color:Colors.white,
                        fontSize:40.0,
                        fontWeight:FontWeight.w600
                    ),
                  ),
                  Padding(
                    padding:EdgeInsets.only(bottom: 10.0),
                    child:Text(
                      currently!=null? currently.toString():"Loading",
                      style:TextStyle(
                          color:Colors.white,
                          fontSize:14.0,
                          fontWeight:FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                      title: Text("Temperture", style: TextStyle(fontFamily: 'Raleway-Italic'),),
                      trailing: Text( temp!=null? temp.toString()+"52\u0000":"Loading"),

                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.cloud),
                      title: Text("Weather"),
                      trailing: Text( description!=null? description.toString():"Loading"),

                    ),   ListTile(
                      leading: FaIcon(FontAwesomeIcons.sun),
                      title: Text("humidity"),
                      trailing: Text(humidity!=null? humidity.toString():"Loading"),

                    ),
                    ListTile(
                      leading: FaIcon(FontAwesomeIcons.wind),
                      title: Text("Wind Speed"),
                      trailing: Text(windSpeed!=null? windSpeed.toString():"Loading"),

                    ),

                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }


}

