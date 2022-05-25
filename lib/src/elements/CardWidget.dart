import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Market market;
  String heroTag;

  CardWidget({Key key, this.market, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Image of the card
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Hero(
                tag: this.heroTag + market.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: market.image.url,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  ),
                ),
              ),
              // Row(
              //   children: <Widget>[
              //     Container(
              //       margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              //       decoration:
              //           BoxDecoration(color: market.closed ? Colors.grey : Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(24)),
              //       child: market.closed
              //           ? Text(
              //               S.of(context).closed,
              //               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
              //             )
              //           : Text(
              //               S.of(context).open,
              //               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
              //             ),
              //     ),
              //     Container(
              //       margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              //       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              //       decoration: BoxDecoration(
              //           color: Helper.canDelivery(market) ? Theme.of(context).highlightColor : Theme.of(context).buttonColor,
              //           borderRadius: BorderRadius.circular(24)),
              //       child: Helper.canDelivery(market)
              //           ? Text(
              //               S.of(context).delivery,
              //               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
              //             )
              //           : Text(
              //               S.of(context).pickup,
              //               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
              //             ),
              //     ),
              //   ],
              // ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        market.name,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(
                              color: Theme.of(context).accentColor,
                            )),
                      ),
                      Text(
                        Helper.skipHtml(market.description),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .merge(TextStyle(color: Theme.of(context).dividerColor.withOpacity(0.8), fontSize: 12)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            decoration:
                            BoxDecoration(color: market.closed ? Colors.grey : Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(24)),
                            child: market.closed
                                ? Text(
                              S.of(context).closed,
                              style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            )
                                : Text(
                              S.of(context).open,
                              style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                            decoration: BoxDecoration(
                                color: Helper.canDelivery(market) ? Theme.of(context).highlightColor : Theme.of(context).buttonColor,
                                borderRadius: BorderRadius.circular(24)),
                            child: Helper.canDelivery(market)
                                ? Text(
                              S.of(context).delivery,
                              style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            )
                                : Text(
                              S.of(context).pickup,
                              style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: Helper.getStarsList(double.parse(market.rate)),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      MaterialButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        elevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                        highlightElevation: 0,
                        height: 40,
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '0', param: market));
                        },
                        child: Icon(Icons.directions_outlined, color: Theme.of(context).primaryColor),
                        color: Theme.of(context).buttonColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      Visibility(
                        visible: market.distance > 0 ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            Helper.getDistance(market.distance, Helper.of(context).trans(setting.value.distanceUnit)),
                            // overflow: TextOverflow.ellipsis,
                            // maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .merge(TextStyle(fontSize: 12,color: Theme.of(context).accentColor, fontWeight: FontWeight.w400)),
                            // softWrap: false,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
