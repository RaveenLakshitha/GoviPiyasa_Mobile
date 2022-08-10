import 'dart:convert';
DataModel dataModelFromJson(String str)=>DataModel.fromJson(json.decode(str));
String dataModelToJson(DataModel data)=>json.encode(data.toJson());
class DataModel{
  String itemname;
  String description;
  String price;
  String quantity;
  String category;
  String deliverystatus;
  String image;



  DataModel({
    this.itemname,
    this.description,
    this.price,
    this.quantity,
    this.category,
    this.deliverystatus,
    this.image,
  });

  factory DataModel.fromJson(Map<String,dynamic> json)=>DataModel(
      itemname: json['itemname'],
      description:json['description'],
      price:json['price'],
      quantity:json['quantity'],
      category:json['category'],
      deliverystatus:json['deliverystatus'],
      image:json['image']
  );
  Map<String,dynamic> toJson()=>{
    "itemname":itemname,
    "description":description,
    "price":price,
    "quantity":quantity,
    "category":category,
    "deliverystatus":deliverystatus,
    "image":image,
  };

}