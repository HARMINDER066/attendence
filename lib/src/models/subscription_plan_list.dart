
import '../helpers/custom_trace.dart';

class SubscriptionsPlanList {

  String id;
  String name;
  String description;
  String amount;
  String subscription_type;
  String subscription_duration;
  String created_at;
  String updated_at;
  bool isRadioSelected;

  SubscriptionsPlanList();

  SubscriptionsPlanList.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      description = jsonMap['description'];
      amount = jsonMap['amount'].toString();
      subscription_type = jsonMap['subscription_type'];
      subscription_duration = jsonMap['subscription_duration'].toString();
      created_at = jsonMap['created_at'];
      updated_at = jsonMap['updated_at'];
      isRadioSelected= false;
    } catch (e) {
      id = '';
      name = '';
      description = '';
      amount = '';
      subscription_type = '';
      subscription_duration = '';
      created_at = '';
      updated_at = '';
      isRadioSelected = false;
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}