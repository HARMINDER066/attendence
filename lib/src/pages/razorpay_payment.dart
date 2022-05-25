import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../generated/l10n.dart';
import '../controllers/razorpay_controller.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class RazorPayPaymentWidget extends StatefulWidget {
  RouteArgument routeArgument;

  RazorPayPaymentWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _RazorPayPaymentWidgetState createState() => _RazorPayPaymentWidgetState();
}

class _RazorPayPaymentWidgetState extends StateMVC<RazorPayPaymentWidget> {
  RazorPayController _con;

  _RazorPayPaymentWidgetState() : super(RazorPayController()) {
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
              initialUrl: _con.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _con.webView = controller;
              },
              onPageStarted: (String url) {
                setState(() {
                  _con.url = url;
                });
                if (url == "${GlobalConfiguration().getValue('base_url')}payments/razorpay") {
                  Navigator.of(context).pushReplacementNamed('/Pages', arguments: 3);
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
