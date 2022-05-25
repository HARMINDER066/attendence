import 'package:eighttoeightneeds/src/controllers/subscriptions_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../generated/l10n.dart';
import '../models/route_argument.dart';

class SubscriptionsPayments extends StatefulWidget {
  RouteArgument routeArgument;
  String planId;

  SubscriptionsPayments({Key key, this.routeArgument, this.planId}) : super(key: key);

  @override
  SubscriptionsPaymentsState createState() => SubscriptionsPaymentsState();
}

class SubscriptionsPaymentsState extends StateMVC<SubscriptionsPayments> {
  SubscriptionsPaymentController _con;

  SubscriptionsPaymentsState() : super(SubscriptionsPaymentController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
        title: Text(
          S.of(context).razorpayPayment,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
              initialUrl: _con.url+"&plan_id=${widget.planId}",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _con.webView = controller;
              },
              onPageStarted: (String url) {
                setState(() {
                  _con.url = url;
                });
                if (url == "${GlobalConfiguration().getValue('base_url')}payments/razorpay") {
                  Navigator.pop(context);
                  Navigator.of(context).popAndPushNamed('/MyMembership');
                }
              },
              onPageFinished: (String url) {
                setState(() {
                  _con.progress = 1;
                });
              }),
          _con.progress < 1
              ? SizedBox(
            height: 2,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            ),
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
