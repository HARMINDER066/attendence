import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../models/media.dart';
import '../models/route_argument.dart';
import 'package:string_validator/string_validator.dart';

import '../models/chat.dart';
import '../repository/user_repository.dart';

class ChatMessageListItem extends StatelessWidget {

  final Chat chat;
  RouteArgument routeArgument;

  ChatMessageListItem({this.chat,this.routeArgument});

  @override
  Widget build(BuildContext context) {

     if(currentUser.value.id == this.chat.userId){
       if (isURL(chat.text)) {
         return getSentMessageImageLayout(context);
       } else {
         return getSentMessageTextLayout(context);
       }
     }else{
       if (isURL(chat.text)) {
         return getReceivedMessageImageLayout(context);
       } else {
         return getReceivedMessageTextLayout(context);
       }
     }

  }
  Widget getSentMessageImageLayout(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(this.chat.user.name, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w600))),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Gallery', arguments: new RouteArgument(
                                heroTag: 'chat_image',
                                param: {
                                  'media': [new Media(id: this.chat.text, url: this.chat.text)],
                                  'current': new Media(id: this.chat.text, url: this.chat.text),
                                }

                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                              imageUrl: this.chat.text,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.link_outlined),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  width: 42,
                  height: 42,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: this.chat.user.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat('HH:mm | d, MMMM y').format(DateTime.fromMillisecondsSinceEpoch(this.chat.time)),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  Widget getSentMessageTextLayout(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(this.chat.user.name, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w600))),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(chat.text),
                      ),
                    ],
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  width: 42,
                  height: 42,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: this.chat.user.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat('HH:mm | d, MMMM y').format(DateTime.fromMillisecondsSinceEpoch(this.chat.time)),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  Widget getReceivedMessageImageLayout(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 42,
                  height: 42,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: this.chat.user.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(this.chat.user.name, style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor))),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Gallery', arguments: new RouteArgument(
                                  heroTag: 'chat_image',
                                  param: {
                                    'media': [new Media(id: this.chat.text, url: this.chat.text)],
                                    'current': new Media(id: this.chat.text, url: this.chat.text),
                                  }

                            ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              height: 200,
                              imageUrl: this.chat.text,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.link_outlined),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat('HH:mm | d, MMMM y').format(DateTime.fromMillisecondsSinceEpoch(this.chat.time)),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],
      ),
    );
  }

  Widget getReceivedMessageTextLayout(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 42,
                  height: 42,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(42)),
                    child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: this.chat.user.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
                new Flexible(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(this.chat.user.name,
                          style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor))),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(
                          chat.text,
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat('HH:mm | d, MMMM y').format(DateTime.fromMillisecondsSinceEpoch(this.chat.time)),
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.caption,
            ),
          )
        ],

      ),
    );
  }
}
