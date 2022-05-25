import '../helpers/custom_trace.dart';

class MyMembershipModel {

  String id;
  String plan_name;
  String paid_amount;
  String txn_id;
  String subscription_type;
  String subscription_duration;
  String activated_at;
  String expired_at;
  String payment_method;
  String status;

  MyMembershipModel();

  MyMembershipModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      plan_name = jsonMap['plan_name'];
      paid_amount = jsonMap['paid_amount'].toString();
      txn_id = jsonMap['txn_id'];
      subscription_type = jsonMap['subscription_type'];
      subscription_duration = jsonMap['subscription_duration'].toString();
      activated_at = jsonMap['activated_at'];
      expired_at = jsonMap['expired_at'];
      payment_method = jsonMap['payment_method'];
      status = jsonMap['status'];
    } catch (e) {
      id = '';
      plan_name = '';
      paid_amount = '';
      txn_id = '';
      subscription_type = '';
      subscription_duration = '';
      activated_at = '';
      expired_at = '';
      payment_method = '';
      status = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}