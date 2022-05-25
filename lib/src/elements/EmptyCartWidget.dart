import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyCartWidget extends StatefulWidget {
  EmptyCartWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
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
  Widget build(BuildContext context) {loading
      ? SizedBox(
    height: 3,
    child: LinearProgressIndicator(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
    ),
  )
      : SizedBox();
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
          ),
        ) : SizedBox(),
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
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color:  Theme.of(context).primaryColor,),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Theme.of(context).accentColor,
                  size: 70,
                ),
              ),
              SizedBox(height: 15),
              Opacity(
                opacity: 0.5,
                child: Text(
                 "Don\'t have any item in your cart",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),
                ),
              ),
              SizedBox(height: 50),
              MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                      elevation: 0,
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Pages', arguments: 2);
                      },
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      color: Theme.of(context).buttonColor,
                      shape: StadiumBorder(),
                      child: Text(
                        S.of(context).start_exploring,
                        style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}
