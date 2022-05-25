import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/app_config.dart' as config;

class PermissionDeniedWidget extends StatefulWidget {
  PermissionDeniedWidget({
    Key key,
  }) : super(key: key);

  @override
  _PermissionDeniedWidgetState createState() => _PermissionDeniedWidgetState();
}

class _PermissionDeniedWidgetState extends State<PermissionDeniedWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                color:  Theme.of(context).primaryColor,
              ),
            child: Icon(
              Icons.https_outlined,
              color: Theme.of(context).accentColor,
              size: 70,
            ),
          ),
          SizedBox(height: 15),
          Opacity(
            opacity: 0.5,
            child: Text(
              S.of(context).you_must_signin_to_access_to_this_section,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 50),
          MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              Navigator.of(context).pushNamed('/Login');
            },
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 70),
            color: Theme.of(context).buttonColor.withOpacity(1),
            shape: StadiumBorder(),
            child: Text(
              S.of(context).login,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
            ),
          ),
          SizedBox(height: 20),

          //signup
          // MaterialButton(
          //   elevation: 0,
          //   onPressed: () {
          //     Navigator.of(context).pushReplacementNamed('/SignUp');
          //   },
          //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
          //   shape: StadiumBorder(),
          //   child: Text(
          //     S.of(context).i_dont_have_an_account,
          //     style: TextStyle(color: Theme.of(context).focusColor),
          //   ),
          // ),
        ],
      ),
    );
  }
}
