import 'dart:convert';
Qmodel qModelFromJson(String str)=>Qmodel.fromJson(json.decode(str));
String  qModelToJson(Qmodel data)=>json.encode(data.toJson());
class Qmodel{
  String Title;
  String QuestionBody;
  String Category;




  Qmodel({
    this.Title,
    this.QuestionBody,
    this.Category,

  });

  factory Qmodel.fromJson(Map<String,dynamic> json)=>Qmodel(
    Title: json['Title'],
    QuestionBody:json['QuestionBody'],
    Category:json['Category'],

  );
  Map<String,dynamic> toJson()=>{
    "Title":Title,
    "QuestionBody":QuestionBody,
    "Category":Category,

  };

}