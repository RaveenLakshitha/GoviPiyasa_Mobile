

import 'dart:convert';

import 'package:blogapp/Forum/searchquestion/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class FetchUserList {
  var data = [];
  List<Qtylist> results = [];

  final storage = FlutterSecureStorage();

  String urlList='https://govi-piyasa-v-0-1.herokuapp.com/api/v1/forum/Questions/getMyQuestions';
  Future<List< Qtylist >> getuserList({String query}) async {
    String token = await storage.read(key: "token");
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url,headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',});
      if (response.statusCode == 200) {
//print(response.body);
        data = json.decode(response.body)['data'];
        print("working");
        print(data);
        results = data.map((e) => Qtylist .fromJson(e)).toList();
        print(results);
        if (query!= null){
          results = results.where((element) => element.Title.toLowerCase().contains((query.toLowerCase()))).toList();
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
