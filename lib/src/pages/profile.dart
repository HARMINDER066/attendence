import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/EmptyOrdersWidget.dart';
import '../elements/OrderItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Image.asset('assets/img/icon_sort.png', color: Theme.of(context).hintColor, width: 18, height: 16,),
          onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileAvatarWidget(user: currentUser.value),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 5),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                      horizontalTitleGap: 15,
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor.withOpacity(0.9),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                          ],
                        ),
                        child: Icon(
                          Icons.person_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      title: Text(
                        S.of(context).about,
                        style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 18)),
                      ),
                      subtitle: Text(
                        currentUser.value?.bio ?? "",
                        style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Text(
                  //     currentUser.value?.bio ?? "",
                  //     style: Theme.of(context).textTheme.bodyText2,
                  //   ),
                  // ),
                  // ListTile(
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   leading: Icon(
                  //     Icons.shopping_basket_outlined,
                  //     color: Theme.of(context).hintColor,
                  //   ),
                  //   title: Text(
                  //     S.of(context).recent_orders,
                  //     style: Theme.of(context).textTheme.headline4,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10, bottom: 10),
                    child: Text(
                      S.of(context).recent_orders,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  _con.recentOrders.isEmpty
                      ? EmptyOrdersWidget()
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.recentOrders.length,
                          itemBuilder: (context, index) {
                            var _order = _con.recentOrders.elementAt(index);
                            return OrderItemWidget(expanded: index == 0 ? true : false, order: _order);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
