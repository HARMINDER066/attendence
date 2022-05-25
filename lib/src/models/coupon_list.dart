import 'package:eighttoeightneeds/src/helpers/custom_trace.dart';

class CouponList {
  String id;
  String code;
  double discount;
  String discount_type;
  String description;
  String expires_at;
  String couponImage;
  bool enabled;

  CouponList();

  CouponList.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      code = jsonMap['code'] != null ? jsonMap['code'].toString() : "";
      discount = jsonMap['discount'] != null ? jsonMap['discount'].toDouble() : 0.0;
      discount_type = jsonMap['discount_type'] != null ? jsonMap['discount_type'] : "";
      description = jsonMap['description'] != null ? jsonMap['description'] : "";
      expires_at = jsonMap['expires_at'] != null ? jsonMap['expires_at'] : "";
      enabled = jsonMap['enabled'] != null ? jsonMap['enabled'] : false;
      couponImage = "";
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}