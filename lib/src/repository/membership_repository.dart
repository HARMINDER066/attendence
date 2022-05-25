

import 'dart:convert';

import '../helpers/custom_trace.dart';
import '../models/my_membership_model.dart';
import '../models/subscription_plan_list.dart';
import 'package:global_configuration/global_configuration.dart';
import '../helpers/helper.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart' as userRepo;

Future<Stream<MyMembershipModel>> getActiveMembership() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}mySubList?api_token=${userRepo.currentUser.value.apiToken}';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return MyMembershipModel.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new MyMembershipModel.fromJSON({}));
  }
}

Future<Stream<SubscriptionsPlanList>> getSubscriptionPlans() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}plan_list';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return SubscriptionsPlanList.fromJSON(data);
      });
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new SubscriptionsPlanList.fromJSON({}));
  }
}
