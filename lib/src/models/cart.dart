
import '../helpers/custom_trace.dart';
import '../models/option.dart';
import '../models/product.dart';

class Cart {
  String id;
  Product product;
  double quantity;
  List<Option> options;
  String userId;
  double min_order_amount;
  int subs_user_status;

  Cart();

  Cart.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      quantity = jsonMap['quantity'] != null ? jsonMap['quantity'].toDouble() : 0.0;
      min_order_amount = jsonMap['min_order_amount'] != null ? jsonMap['min_order_amount'].toDouble() : 0.0;
      subs_user_status = jsonMap['subs_user_status'] != null ? jsonMap['subs_user_status'] : 0;
      product = jsonMap['product'] != null ? Product.fromJSON(jsonMap['product']) : Product.fromJSON({});
      options = jsonMap['options'] != null ? List.from(jsonMap['options']).map((element) => Option.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      quantity = 0.0;
      min_order_amount = 0.0;
      subs_user_status = 0;
      product = Product.fromJSON({});
      options = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["quantity"] = quantity;
    map["product_id"] = product.id;
    map["user_id"] = userId;
    map["options"] = options.map((element) => element.id).toList();
    return map;
  }

  double getProductPrice() {
    double result = product.price;

    if (options.isNotEmpty) {
      options.forEach((Option option) {
        if(option.checked){
          result= 0.0;
        }else{
          result= 0.0;
        }
        result += option.price != null ? option.price : 0;
        result *= quantity;
      });
    }else{
      result *= quantity;
    }
    return result;
  }

  bool isSame(Cart cart) {
    bool _same = true;
    _same &= this.product == cart.product;
    _same &= this.options.length == cart.options.length;
    if (_same) {
      this.options.forEach((Option _option) {
        _same &= cart.options.contains(_option);
      });
    }
    return _same;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
