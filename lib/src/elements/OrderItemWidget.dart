import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/order.dart';
import '../models/route_argument.dart';
import 'ProductOrderItemWidget.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;
  final ValueChanged<void> onCanceled;

  OrderItemWidget({Key key, this.expanded, this.order, this.onCanceled}) : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {

  double quantity = 0;

  @override
  void initState() {
    widget.order.productOrders.forEach((element) {
      quantity +=element.quantity;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${S.of(context).order_id}: #${widget.order.id}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  DateFormat('dd-MM-yyyy | HH:mm').format(widget.order.dateTime),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      " ${S.of(context).quantity}: ",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      quantity.toString(),
                      style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      " ${S.of(context).total}:  ",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context,
                        style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 14))),
                  ],
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 4,top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.order.active ? '${widget.order.orderStatus.status}' : S.of(context).canceled,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color:  widget.order.active? Theme.of(context).highlightColor:Colors.redAccent , fontWeight: FontWeight.w600)),
                ),
                Text(
                  '${widget.order.payment.method}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 4,top: 15.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed('/Tracking', arguments: RouteArgument(id: widget.order.id));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                    border: Border.all(color: Theme.of(context).accentColor),
                        color: Theme.of(context).accentColor
                    ),

                    child: Text(S.of(context).viewDetails, style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ),
                if (widget.order.canCancelOrder())
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: Wrap(
                                spacing: 10,
                                children: <Widget>[
                                  Icon(Icons.report_outlined, color: Colors.orange),
                                  Text(
                                    S.of(context).confirmation,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ],
                              ),
                              content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                              contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                              actions: <Widget>[
                                MaterialButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  elevation: 0,
                                  child: new Text(
                                    S.of(context).yes,
                                    style: TextStyle(color: Theme.of(context).hintColor),
                                  ),
                                  onPressed: () {
                                    widget.onCanceled(widget.order);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                MaterialButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  elevation: 0,
                                  child: new Text(
                                    S.of(context).close,
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Theme.of(context).accentColor)
                        ),
                        child: Text(S.of(context).cancelOrder),
                      ),
                    ),
                  ),
              ],
            ),
          ),


          //old flow
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: widget.order.active ? 1 : 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 14),
                          padding: EdgeInsets.only(top: 20, bottom: 5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.9),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Theme(
                            data: theme,
                            child: ExpansionTile(
                              initiallyExpanded: widget.expanded,
                              title: Column(
                                children: <Widget>[
                                  Text('${S.of(context).order_id}: #${widget.order.id}'),
                                  Text(
                                    DateFormat('dd-MM-yyyy | HH:mm').format(widget.order.dateTime),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context,
                                      style: Theme.of(context).textTheme.headline4),
                                  Text(
                                    '${widget.order.payment.method}',
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                              children: <Widget>[
                                Column(
                                    children: List.generate(
                                  widget.order.productOrders.length,
                                  (indexProduct) {
                                    return ProductOrderItemWidget(
                                        heroTag: 'mywidget.orders',
                                        order: widget.order,
                                        productOrder: widget.order.productOrders.elementAt(indexProduct));
                                  },
                                )),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).delivery_fee,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                          Helper.getPrice(widget.order.deliveryFee, context,
                                              style: Theme.of(context).textTheme.subtitle1)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              '${S.of(context).tax} (${widget.order.tax}%)',
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                          Helper.getPrice(Helper.getTaxOrder(widget.order), context,
                                              style: Theme.of(context).textTheme.subtitle1)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).total,
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                          Helper.getPrice(Helper.getTotalOrdersPrice(widget.order), context,
                                              style: Theme.of(context).textTheme.headline4)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            children: <Widget>[
                              MaterialButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/Tracking', arguments: RouteArgument(id: widget.order.id));
                                },
                                textColor: Theme.of(context).hintColor,
                                child: Wrap(
                                  children: <Widget>[Text(S.of(context).view)],
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 0),
                              ),
                              if (widget.order.canCancelOrder())
                                MaterialButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: Wrap(
                                            spacing: 10,
                                            children: <Widget>[
                                              Icon(Icons.report_outlined, color: Colors.orange),
                                              Text(
                                                S.of(context).confirmation,
                                                style: TextStyle(color: Colors.orange),
                                              ),
                                            ],
                                          ),
                                          content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                          actions: <Widget>[
                                            MaterialButton(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              elevation: 0,
                                              child: new Text(
                                                S.of(context).yes,
                                                style: TextStyle(color: Theme.of(context).hintColor),
                                              ),
                                              onPressed: () {
                                                widget.onCanceled(widget.order);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            MaterialButton(
                                              splashColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              elevation: 0,
                                              child: new Text(
                                                S.of(context).close,
                                                style: TextStyle(color: Colors.orange),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  textColor: Theme.of(context).hintColor,
                                  child: Wrap(
                                    children: <Widget>[Text(S.of(context).cancel + " ")],
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(start: 20),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 28,
                    width: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: widget.order.active ? Theme.of(context).accentColor : Colors.redAccent),
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      widget.order.active ? '${widget.order.orderStatus.status}' : S.of(context).canceled,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
