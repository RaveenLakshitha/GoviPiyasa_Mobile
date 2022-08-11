class todo {
  final int id;
  final String title;
  final String description;

  todo({
     this.id,
     this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  todo.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        description = res["description"];

  @override
  String toString() {
    return 'todo{id: $id, title: $title, description: $description}';
  }
}