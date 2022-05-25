import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyOrdersWidget extends StatefulWidget {
  EmptyOrdersWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyOrdersWidgetState createState() => _EmptyOrdersWidgetState();
}

class _EmptyOrdersWidgetState extends State<EmptyOrdersWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App(context).appHeight(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor
                    // gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                    //   Theme.of(context).focusColor.withOpacity(0.7),
                    //   Theme.of(context).focusColor.withOpacity(0.05),
                    // ])
                  ),
                child: Image.asset('assets/img/icon_empty_order.png'),
              ),
              SizedBox(height: 30),
              Opacity(
                opacity: 0.5,
                child: Text(
                  S.of(context).youDontHaveAnyOrder,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
  }
}
