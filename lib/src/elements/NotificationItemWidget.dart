import 'package:eighttoeightneeds/src/models/route_argument.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../helpers/helper.dart';
import '../helpers/swipe_widget.dart';
import '../models/notification.dart' as model;

class NotificationItemWidget extends StatelessWidget {
  final model.Notification notification;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnRead;
  final VoidCallback onRemoved;

  NotificationItemWidget({Key key, this.notification, this.onMarkAsRead, this.onMarkAsUnRead, this.onRemoved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnSlide(
      // backgroundColor: notification.read ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      items: <ActionItems>[
        // ActionItems(
        //     icon: notification.read
        //         ? new Icon(
        //             Icons.panorama_fish_eye,
        //             color: Theme.of(context).accentColor,
        //           )
        //         : new Icon(
        //             Icons.brightness_1,
        //             color: Theme.of(context).accentColor,
        //           ),
        //     onPress: () {
        //       if (notification.read) {
        //         onMarkAsUnRead();
        //       } else {
        //         onMarkAsRead();
        //       }
        //     },
        //     backgroudColor: Theme.of(context).scaffoldBackgroundColor),
        new ActionItems(
            icon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: new Icon(Icons.delete_outline, color: Theme.of(context).accentColor),
            ),
            onPress: () {
              onRemoved();
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      child: InkWell(
        onTap: (){
          // Navigator.of(context).pushNamed('/Pages', arguments: 3);
          Navigator.of(context).pushNamed('/Tracking', arguments: RouteArgument(id: notification.order_id));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                    color:  Theme.of(context).accentColor.withOpacity(0.05),),
                    child: Icon(
                      Icons.notifications_active,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      // Helper.of(context).trans(notification.type),
                      notification.title==""?Helper.of(context).trans(notification.type) :notification.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w300)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context).accentColor.withOpacity(0.6),
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            // DateFormat('yyyy-MM-dd | HH:mm').format(notification.createdAt),
                            TimeAgo.timeAgoSinceDate(DateFormat('dd-MM-yyyy h:mma').format(notification.createdAt)),
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class TimeAgo{
  static String timeAgoSinceDate(String dateString, {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 min ago' : 'A min ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
