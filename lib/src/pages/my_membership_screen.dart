import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/my_membership_controller.dart';
import '../helpers/helper.dart';

class MyMembershipScreen extends StatefulWidget {
  @override
  MyMembershipScreenState createState() => MyMembershipScreenState();
}

class MyMembershipScreenState extends StateMVC<MyMembershipScreen> {
  MyMembershipController _con;

  MyMembershipScreenState() : super(MyMembershipController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForActiveMembership();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          S.of(context).my_membership,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshMembership,
        child: _con.mymembership.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Image.asset(
                          'assets/img/img_no_membership.png',
                        ),
                        color: Theme.of(context).focusColor.withOpacity(1),
                        iconSize: 110,
                        onPressed: () {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            S.of(context).no_active_membership,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            elevation: 0,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/AllMembershipPlan');
                            },
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                            shape: StadiumBorder(),
                            child: Text(
                              S.of(context).buy_now,
                              style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _con.mymembership.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _con.mymembership[index].subscription_duration +" " +_con.mymembership[index].subscription_type+ " / ",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Helper.getPrice(
                                      double.parse(_con.mymembership[index].paid_amount),
                                      context,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: _con.mymembership[index].status == "Active" ? Colors.green : Colors.orange,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Text(
                                    _con.mymembership[index].status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).activated_on,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    _con.mymembership[index].activated_at,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).dividerColor.withOpacity(0.15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).expires_on,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    _con.mymembership[index].expired_at,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).dividerColor.withOpacity(0.15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).transaction_id,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    _con.mymembership[index].txn_id,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).dividerColor.withOpacity(0.15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    S.of(context).payment_method,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                  Text(
                                    _con.mymembership[index].payment_method,
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: MaterialButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            elevation: 0,
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/AllMembershipPlan');
                            },
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                            shape: StadiumBorder(),
                            child: Text(
                              S.of(context).buy_now,
                              style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
