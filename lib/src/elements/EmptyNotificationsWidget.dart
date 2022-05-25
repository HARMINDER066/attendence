import 'dart:async';

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class EmptyNotificationsWidget extends StatefulWidget {
  EmptyNotificationsWidget({
    Key key,
  }) : super(key: key);

  @override
  _EmptyNotificationsWidgetState createState() => _EmptyNotificationsWidgetState();
}

class _EmptyNotificationsWidgetState extends State<EmptyNotificationsWidget> {
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
      children: <Widget>[
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
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      color:  Theme.of(context).primaryColor,),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Theme.of(context).accentColor,
                      size: 70,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Opacity(
                opacity: 0.5,
                child: Text(
                  S.of(context).dont_have_any_item_in_the_notification_list,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,),
                ),
              ),
              SizedBox(height: 50),
              // !loading ?
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
                  // : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
