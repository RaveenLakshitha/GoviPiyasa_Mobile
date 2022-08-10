

import 'dart:convert';

import 'package:blogapp/Search/user_model.dart';
import 'package:http/http.dart' as http;


class FetchUserList {
  var data = [];
  List<Userlist> results = [];
  // String urlList = 'https://jsonplaceholder.typicode.com/users/';
  //String urlList = 'https://jsonplaceholder.typicode.com/users/';
  String urlList='https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items';
//  String urlList='https://mongoapi3.herokuapp.com/items';
  Future<List<Userlist>> getuserList({String query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
//print(response.body);
        data = json.decode(response.body)['data'];
        //print("working");
        //print(data);
        results = data.map((e) => Userlist.fromJson(e)).toList();
        print(results);
        if (query!= null){
          results = results.where((element) => element.productName.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fet error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
