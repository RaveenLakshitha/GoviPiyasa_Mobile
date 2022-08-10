class Qtylist {

  String Title;
  String QuestionBody;
  String Category;



  Qtylist(

      {  this.Title,
        this.QuestionBody,
        this.Category,
        });

  Qtylist.fromJson(Map<String, dynamic> json) {

    Title= json['Title'];
    QuestionBody=json['QuestionBody'];
    Category=json['Category'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title']=this.Title;
    data['QuestionBody'] = this.QuestionBody;
    data['Category'] = this.Category;
    return data;
  }
}

