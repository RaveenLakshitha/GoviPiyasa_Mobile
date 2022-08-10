import 'package:flutter/cupertino.dart';

class Bank{


  final int id;
  final String cardNo;
  final String expiredate;
  final String ccv;
  Bank({

    @required this.id,
    @required this.cardNo,
    @required this.expiredate,
    @required this.ccv,
});
  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'cardNo':cardNo,
      'expiredate':expiredate,
      'ccv':ccv,
    };
  }

  Bank.fromMap(Map<String,dynamic> res):
      id=res["id"],
      cardNo=res["cardNo"],
      expiredate=res["expiredate"],
      ccv=res["ccv"];

  @override
  String toString(){
    return  'Bank {id:$id,cardNo:$cardNo,expiredate:$expiredate,ccv:$ccv}';
  }


}