class Userlist {
  int id;
  String categoryName;
  String productName;
  int quantity;
  Address address;
  int price;
  String description;
  Company company;

  Userlist(
      {this.id,
        this.categoryName,
        this.productName,
        this.quantity,
        this.address,
        this.price,
        this.description,
        this.company});

  Userlist.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    categoryName = json['categoryName'];
    productName = json['productName'];
    quantity = json['quantity'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    price = json['price'];
    description = json['description'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    if (this.address != null) {
      data['address'] = this.address?.toJson();
    }
    data['price'] = this.price;
    data['description'] = this.description;
    if (this.company != null) {
      data['company'] = this.company?.toJson();
    }
    return data;
  }
}

class Address {
  String street;
  String suite;
  String city;
  String zipcode;
  Geo geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    suite = json['suite'];
    city = json['city'];
    zipcode = json['zipcode'];
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['suite'] = this.suite;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    if (this.geo != null) {
      data['geo'] = this.geo?.toJson();
    }
    return data;
  }
}

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