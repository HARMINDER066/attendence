import '../helpers/custom_trace.dart';
import '../models/media.dart';
import '../models/subcategory.dart';
import 'dart:convert';


class Category {
  String id;
  String name;
  String description;
  Media image;
  List<Subcategory> item;

 // Subcategory item;

  Category();

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      description = jsonMap['description'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
      item =
      jsonMap['subcategory'] != null && (jsonMap['subcategory'] as List).length > 0 ? List.from(jsonMap['subcategory']).map((element) => Subcategory.fromJSON(element)).toSet().toList() : [];

     // item = jsonMap['subcategory'] != null && (jsonMap['subcategory'] as List).length > 0 ? new Subcategory() : Subcategory.fromJSON(jsonMap['subcategory']);

    } catch (e) {
      id = '';
      name = '';
      description = '';
      image = new Media();
      item = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
