class Userlist {

  //String avilability;
  //bool itemVisibility;
  String id;
  String productName;
  int price;
  String description;
  int quantity;
  String categoryName;
  ShopId shopId;
  String rating;



  Userlist(

      { this.id,
        this.productName,
        this.price,
        this.description,
        this.quantity,
        this.categoryName,
        this.shopId,
        this.rating,

      });

  Userlist.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['productName'];
    price = json['price'];
    description = json['description'];
    quantity = json['quantity'];
    categoryName = json['categoryName'];
    shopId = json['shopId'] != null ? new ShopId.fromJson(json['shopId']): null;
    rating = json['rating'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id']=this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['description'] = this.description;
    data['quantity']=this. quantity ;
    data['categoryName']=this.categoryName;
    data['shopId']=this.shopId;
    data['rating']=this.rating;

    return data;
  }
}


class ShopId {
  String id;


  ShopId({this.id});

  ShopId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;

    return data;
  }
}
/*

class Geo {
  String lat;
  String lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Company {
  String name;
  String catchPhrase;
  String bs;

  Company({this.name, this.catchPhrase, this.bs});

  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    catchPhrase = json['catchPhrase'];
    bs = json['bs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['catchPhrase'] = this.catchPhrase;
    data['bs'] = this.bs;
    return data;
  }
}
*/
