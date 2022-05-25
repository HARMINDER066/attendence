import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/checkout_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/helper.dart';
import '../models/payment.dart';
import '../models/route_argument.dart';

class OrderSuccessWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  OrderSuccessWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends StateMVC<OrderSuccessWidget> {
  CheckoutController _con;

  _OrderSuccessWidgetState() : super(CheckoutController()) {
    _con = controller;
  }

  @override
  void initState() {
    // route param contains the payment method
    _con.payment = new Payment(widget.routeArgument.param);
    _con.listenForCarts();

    if(_con.payment.method == 'Pay on Pickup'){
      setState(() {
        _con.selectedPickup = true;
        _con.calculateSubtotal();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed('/Pages', arguments: 2);
        return Future.value(true);
      },
      child: Scaffold(
          key: _con.scaffoldKey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 2);
              },
              icon: Icon(Icons.arrow_back),
              color: Theme.of(context).hintColor,
            ),
            bottom: PreferredSize(
                child: Container(
                  color: Theme.of(context).hintColor.withOpacity(0.2),
                  height: 0.5,
                ),
                preferredSize: Size.fromHeight(4.0)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              S.of(context).confirmation,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
          ),
          bottomNavigationBar:  Visibility(
            visible:  _con.carts.isNotEmpty,
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                Navigator.of(context).pushNamed('/Pages', arguments: 3);
              },
              padding: EdgeInsets.symmetric(vertical: 14),
              color: Theme.of(context).buttonColor,
              disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
              child: Text(
                S.of(context).my_orders,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          body: _con.carts.isEmpty
              ? CircularLoadingWidget(height: 500)
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor
                                ),
                                child: _con.loading
                                    ? Padding(
                                        padding: EdgeInsets.all(55),
                                        child: CircularProgressIndicator(
                                          valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                                        ),
                                      )
                                    : Icon(
                                        Icons.check,
                                        color: Theme.of(context).accentColor,
                                        size: 90,
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              S.of(context).your_order_has_been_successfully_submitted,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18,),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, -2), blurRadius: 5.0)]),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  S.of(context).price_details,
                                  style: Theme.of(context).textTheme.subtitle1,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).subtotal,
                                      style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                    ),
                                  ),
                                  Helper.getPrice(_con.appliedCouponDiscountPrice != 0.0?(_con.subTotal+_con.appliedCouponDiscountPrice):_con.subTotal, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: '0')
                                ],
                              ),

                              Visibility(
                                visible:_con.appliedCouponDiscountPrice != 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "Discount",
                                          style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                        ),
                                      ),

                                      Text("- ₹"+_con.appliedCouponDiscountPrice.toString(), style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),)
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 3),
                              _con.payment.method == 'Pay on Pickup'
                                  ? SizedBox(height: 0)
                                  : Visibility(
                                // visible: _con.deliveryFee != 0.0,
                                visible: true,
                                    child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).delivery_fee,
                                              style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                            ),
                                          ),
                                          if(_con.deliveryFee != 0.0)
                                            Helper.getPrice(_con.carts[0].product.market.deliveryFee, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: '0')
                                          else
                                            Text("Free", style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),)
                                        ],
                                      ),
                                  ),
                              SizedBox(height: 3),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)",
                                      style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                    ),
                                  ),
                                  Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: '0')
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Divider(
                                  color: Theme.of(context).dividerColor.withOpacity(0.8),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      S.of(context).total,
                                      style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).accentColor)),
                                    ),
                                  ),
                                  Helper.getPrice(_con.payment.method == 'Pay on Pickup'?((_con.total)-(_con.deliveryFee)):_con.total, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).accentColor)), zeroPlaceholder: '0')
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
