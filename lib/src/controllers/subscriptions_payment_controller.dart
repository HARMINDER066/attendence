import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../repository/user_repository.dart' as userRepo;

class SubscriptionsPaymentController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  String url = "";
  double progress = 0;
  WebViewController webView;

  SubscriptionsPaymentController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    url = '${GlobalConfiguration().getValue('base_url')}subs_plan/payments/razorpay/checkout?$_apiToken';
    print(url);
    setState(() {});
    super.initState();
  }
}