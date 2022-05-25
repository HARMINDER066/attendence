class ProductCart {
  String id;
  String product_id;
  String user_id;
  double quantity;

  ProductCart();

  ProductCart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      product_id = jsonMap['product_id'].toString();
      user_id = jsonMap['user_id'].toString();
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
    } catch (e) {
      id = '';
      product_id = '';
      user_id = '';
      quantity = 0.0;
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["product_id"] = product_id;
    map["user_id"] = user_id;
    return map;
  }
}