import 'package:global_configuration/global_configuration.dart';
import '../models/media.dart';



class Subcategory {
  String id;
  String name;
  String category_id;
  String description;
  String is_active;
  Media image;


  Subcategory();

  Subcategory.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'].toString();
      category_id = jsonMap['category_id'].toString();
      description = jsonMap['description'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
    } catch (e) {
      id = '';
      name = '';
      description = '';
      image = new Media();
      print(e);
    }

  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["category_id"] = category_id;
    map["description"] = description;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
