

import '../models/subscription_plan_list.dart';
import '../repository/membership_repository.dart';

import '../models/my_membership_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MyMembershipController extends ControllerMVC {

  List<MyMembershipModel> mymembership = <MyMembershipModel>[];
  List<SubscriptionsPlanList> subscriptionPlanList = <SubscriptionsPlanList>[];

  MyMembershipController() {
  }

  Future<void> listenForMembership() async {
    final Stream<SubscriptionsPlanList> stream = await getSubscriptionPlans();
    stream.listen((SubscriptionsPlanList subscriptionsPlanList) {
      setState(() => subscriptionPlanList.add(subscriptionsPlanList));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForActiveMembership() async {

    final Stream<MyMembershipModel> stream = await getActiveMembership();
    stream.listen((MyMembershipModel myMembershipModel) {
      setState(() => mymembership.add(myMembershipModel));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshMembership() async {
    setState(() {
      mymembership = <MyMembershipModel>[];
      subscriptionPlanList = <SubscriptionsPlanList>[];
    });
    await listenForMembership();
    await listenForActiveMembership();
  }

}