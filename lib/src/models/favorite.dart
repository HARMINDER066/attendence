import '../models/option.dart';
import '../models/product.dart';
import 'option_group.dart';

class Favorite {
  String id;
  Product product;
  List<Option> options;
  List<OptionGroup> optionGroups;
  String userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : Product.fromJSON({});
      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : null;
      // options =
      // jsonMap['product']['options'] != null && (jsonMap['product']['options'] as List).length > 0 ? List.from(jsonMap['product']['options']).map((element) => Option.fromJSON(element)).toSet().toList() : [];
      // optionGroups = jsonMap['product']['option_groups'] != null && (jsonMap['product']['option_groups'] as List).length > 0
      //     ? List.from(jsonMap['product']['option_groups']).map((element) => OptionGroup.fromJSON(element)).toSet().toList()
      //     : [];

    } catch (e) {
      print("favIdEx-->${e.toString()}");
      id = '';
      product = Product.fromJSON({});
      options = [];
      // optionGroups = [];
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["product_id"] = product.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }
}
