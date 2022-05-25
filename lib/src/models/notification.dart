class Notification {
  String id;
  String type;
  String title;
  String description;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  String order_id;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      title = jsonMap['title'] != null ? jsonMap['title'].toString() : '';
      description = jsonMap['description'] != null ? jsonMap['description'].toString() : '';
      data = jsonMap['data'] != null ? {} : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);

      order_id = jsonMap['order_id'] != null ? jsonMap['order_id'].toString() : '';

    } catch (e) {
      id = '';
      type = '';
      title = '';
      description = '';
      data = {};
      read = false;
      createdAt = new DateTime(0);

      order_id = '';
      print(e);
    }
  }

  Map markReadMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
