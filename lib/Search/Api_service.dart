import 'dart:convert';

import 'package:blogapp/Search/user_model.dart';
import 'package:http/http.dart' as http;

class FetchUserList {
  var data = [];
  List<Userlist> results = [];
  //String urlList = 'https://jsonplaceholder.typicode.com/users/';
  String urlList='https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items';

  Future<List<Userlist>> getuserList({String query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {

        data = json.decode(response.body)['data'];
        results = data.map((e) => Userlist.fromJson(e)).toList();
        if (query!= null){
          results = results.where((element) => element.productName.toLowerCase().contains((query.toLowerCase()))).toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}