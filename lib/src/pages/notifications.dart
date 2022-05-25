import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/notification_controller.dart';
import '../elements/EmptyNotificationsWidget.dart';
import '../elements/NotificationItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class NotificationsWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  NotificationsWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends StateMVC<NotificationsWidget> {
  NotificationController _con;

  _NotificationsWidgetState() : super(NotificationController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Image.asset('assets/img/icon_sort.png', color: Theme.of(context).hintColor, width: 18, height: 16,),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).notifications,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: RefreshIndicator(
                onRefresh: _con.refreshNotifications,
                child: _con.notifications.isEmpty
                    ? EmptyNotificationsWidget()
                    : ListView(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40,),
                            child: ListTile(
                              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                              horizontalTitleGap: 2,
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              leading: Image.asset('assets/img/icon_notifications.png', width: 20, height: 20, color: Theme.of(context).hintColor,),
                              title: Text(
                                S.of(context).notifications,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S.of(context).swipeLeftTheNotificationToDeleteOrReadUnreadIt,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: _con.notifications.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              return NotificationItemWidget(
                                notification: _con.notifications.elementAt(index),
                                onMarkAsRead: () {
                                  _con.doMarkAsReadNotifications(_con.notifications.elementAt(index));
                                },
                                onMarkAsUnRead: () {
                                  _con.doMarkAsUnReadNotifications(_con.notifications.elementAt(index));
                                },
                                onRemoved: () {
                                  _con.doRemoveNotification(_con.notifications.elementAt(index));
                                },
                              );
                            },
                          ),
                        ],
                      ),
              ),
          ),
    );
  }
}
