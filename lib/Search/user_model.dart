class Userlist {

  //String avilability;
  //bool itemVisibility;
  String id;
  String productName;
  int price;
  String description;
  int quantity;
   String parentCategoryName;
  //ShopId shopId;
   int rating;
   Thumbnail thumbnail;
   productPictures1 productPictures;


  Userlist(

      { this.id,
        this.productName,
        this.price,
        this.description,
        this.quantity,
         this.parentCategoryName,
    //     this.shopId,
        this.rating,
         this.thumbnail,
        this.productPictures,


      });

  Userlist.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    productName = json['productName'];
    price = json['price'];
    description = json['description'];
    quantity = json['quantity'];
     parentCategoryName = json['parentCategoryName'];
    //
    // shopId = json['shopId'] != null ? new ShopId.fromJson(json['shopId']): null;
     rating = json['rating'];
     thumbnail = json['thumbnail'][0] != null ? new Thumbnail.fromJson(json['thumbnail'][0]): null;
   // productPictures = json['productPictures'] != null ? new productPictures1.fromJson(json['productPictures']): null;



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id']=this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['description'] = this.description;
    data['quantity']=this. quantity ;
     data['parentCategoryName']=this.parentCategoryName;
    // data['shopId']=this.shopId;
     data['rating']=this.rating;
     data['thumbnail']=this.thumbnail;
    data['productPictures']=this.productPictures;

    return data;
  }
}
class ShopId {
  String id;



  ShopId({this.id});

  ShopId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    //rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    // data['rating'] = this.rating;

    return data;
  }
}

class Thumbnail {
  String img;



  Thumbnail({this.img});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    //rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    // data['rating'] = this.rating;

    return data;
  }
}
class productPictures1{
  String img;



  productPictures1({this.img});

  productPictures1.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    //rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    // data['rating'] = this.rating;

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
