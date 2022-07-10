

import 'package:blogapp/Screen/Services/shop.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ShopService{
  Dio dio =new Dio();
  //SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
  //String token = prefs.getString('token');
  addShop(shopName,sellerName,phoneNo,email,address,city) async {

    return await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops',data:{
      "shopname":shopName,
      "sellername":sellerName,
      "contact":phoneNo,
      "email":email,
      "city":city,
      "address":address,



    },
        options: Options(contentType: Headers.formUrlEncodedContentType)
    );
  }
  addArchitect(AName,phoneNo,about,team) async {
    return await dio.post('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects',data:{
      "name":AName,
      "contact":phoneNo,
      "about":about,
      "team":team



    },
        options: Options(contentType: Headers.formUrlEncodedContentType)
    );
  }
}
