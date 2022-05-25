import 'package:eighttoeightneeds/src/models/product.dart';

class CategorizedProducts{
  String id;
  String category_name;
  List<Product> product;

  CategorizedProducts();

  CategorizedProducts.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      category_name = jsonMap['category_name'].toString();
      product =  jsonMap['products'] != null && (jsonMap['products'] as List).length > 0 ? List.from(jsonMap['products']).map((element) => Product.fromJSON(element)).toSet().toList() : [];
    } catch (e) {
      id = '';
      category_name = '';
      product = [];
      print(e);
    }
  }
}