class Qlist {
  String Id;
  String Title;
  String QuestionBody;
  String Category;



  Qlist(

      { this.Id,
        this.Title,
        this.QuestionBody,
        this.Category,
        });

  Qlist.fromJson(Map<String, dynamic> json) {
    Id= json['_id'];
    Title= json['Title'];
    QuestionBody=json['QuestionBody'];
    Category=json['Category'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id']=this.Id;
    data['Title']=this.Title;
    data['QuestionBody'] = this.QuestionBody;
    data['Category'] = this.Category;
    return data;
  }
}

