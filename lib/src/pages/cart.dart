import 'package:eighttoeightneeds/src/models/coupon.dart';
import 'package:eighttoeightneeds/src/pages/coupon_list_dialog_screen.dart';

import '../elements/EmptyCartWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../elements/CartItemWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';

class CartWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  CartWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends StateMVC<CartWidget> {
  CartController _con;

  _CartWidgetState() : super(CartController()) {
    _con = controller;
  }

  TextEditingController couponController;
  String couponCode = '';
  bool couponApplied = false;

  @override
  void initState() {
    _con.listenForCarts();
    _con.listenForCoupon();
    setState(() {  _con.appliedCouponDiscountPrice = 0.0;});
    couponController = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(couponApplied == true){
          _con.doRemoveCoupon("");
          setState(() {couponApplied =false;});
        }

        Navigator.of(context).pop();

        return Future.value(true);
      },
      child: Scaffold(
        bottomNavigationBar: Visibility(
          visible: _con.carts.isNotEmpty,
          child: Container(
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                _con.goCheckout(context);
              },
              disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 14),
              color: _con.carts.isNotEmpty && !_con.carts[0].product.market.closed
                  ? Theme.of(context).buttonColor
                  : Theme.of(context).focusColor.withOpacity(0.5),
              child: Text(
                S.of(context).checkout,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              if (widget.routeArgument != null) {
                _con.doRemoveCoupon("");
                setState(() {couponApplied =false;});

                Navigator.of(context)
                    .pushReplacementNamed(widget.routeArgument.param, arguments: RouteArgument(id: widget.routeArgument.id));
              } else {
                // coupon.valid = null;
                _con.doRemoveCoupon("");
                setState(() {couponApplied =false;});

                Navigator.of(context).pop();
                // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
              }
            },
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).hintColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).my_cart,
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
          key: _con.scaffoldKey,
          onRefresh: _con.refreshCarts,
          child: _con.carts.isEmpty
              ? EmptyCartWidget()
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            child: ListTile(
                              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                              horizontalTitleGap: 2,
                              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              leading: Icon(
                                Icons.shopping_cart_outlined,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                S.of(context).shopping_cart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                S.of(context).verify_your_quantity_and_click_checkout,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          ListView.separated(
                            padding: EdgeInsets.only(top: 15, bottom: 30),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _con.carts.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              return CartItemWidget(
                                cart: _con.carts.elementAt(index),
                                heroTag: 'cart',
                                increment: () {
                                  _con.incrementQuantity(_con.carts.elementAt(index));
                                },
                                decrement: () {
                                  _con.decrementQuantity(_con.carts.elementAt(index));
                                },
                                onDismissed: () {
                                  couponController.text = "";
                                  setState(() { });
                                  _con.removeFromCart(_con.carts.elementAt(index));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, boxShadow: [
                          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), offset: Offset(0, 2), blurRadius: 5.0)
                        ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      if(value==""){
                                        _con.doRemoveCoupon("");
                                        setState(() {couponApplied =false;});
                                      }
                                    },
                                    onSubmitted: (String value) {
                                      _con.doApplyCoupon(value);
                                      setState(() {couponApplied =true;});
                                    },
                                    cursorColor: Theme.of(context).accentColor,
                                    // controller: TextEditingController()..text = coupon?.code ?? '',
                                    controller: couponController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintStyle: Theme.of(context).textTheme.subtitle2,
                                      // suffixText: coupon?.valid == null || couponApplied == false
                                      //     ? ''
                                      //     : (coupon.valid ? S.of(context).validCouponCode : S.of(context).invalidCouponCode),
                                      // suffixStyle: Theme.of(context).textTheme.caption.merge(TextStyle(color: _con.getCouponIconColor())),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          if(couponController.text.toString() !=""){
                                            if(_con.subTotal < 999.0)
                                            {
                                              ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                                                content: Text("Coupon not Applied Below Rs 999"),
                                                behavior: SnackBarBehavior.floating,
                                              ));
                                            }
                                            else
                                            {
                                              _con.doApplyCoupon(couponController.text.toString());
                                              setState(() {couponApplied =true;});
                                            }

                                          }else{
                                            ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                                                  content: Text("Please enter Coupon code."),
                                                  behavior: SnackBarBehavior.floating,
                                                ));
                                          }

                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Visibility(
                                            //   visible:  couponApplied &&  coupon?.valid != null,
                                            //   child: GestureDetector(
                                            //     onTap: (){
                                            //       setState(() {
                                            //         couponController.text ="";
                                            //         couponApplied= false;
                                            //         _con.doRemoveCoupon("");
                                            //       });
                                            //     },
                                            //     child: Icon(
                                            //       Icons.close,
                                            //       color: Theme.of(context).accentColor,
                                            //       size: 24,
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Text(
                                                S.of(context).apply,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .merge(TextStyle(color: Theme.of(context).highlightColor)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      hintText: S.of(context).haveCouponCode,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.5))),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.2))),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _con.couponList.isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      var data = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return WillPopScope(
                                              onWillPop: () async => false,
                                              child: CouponListDialogScreen(
                                                couponList: _con.couponList,
                                              ),
                                            );
                                          });
                                      if(data !=null && data !=""){
                                       ;
                                        couponController.text = data.toString();
                                        _con.doApplyCoupon(data);
                                        setState(() {couponApplied =true;});
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "See All",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontSize:16, fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 5),
                              child: Visibility(visible: couponApplied &&  coupon?.valid != null,child: Text(coupon.valid == true? (coupon.discountType=="fixed"? "Flat ${coupon.discount.toInt()} Rs. off" : "${coupon.discount.toInt()}% off") +" coupon is applied" : "Invalid coupon code", style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontSize:16, fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),)),
                            ),
                          ],
                        ),
                      ),

                      _con.carts.isEmpty
                          ? SizedBox(height: 0)
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _con.subTotal < 299.0 ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,),
                                    child: Text(
                                      "Free Delivery on order of 299/- & Above",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontSize:16, fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),
                                    ),
                                  ):SizedBox(height: 5.0),
                                  SizedBox(height: 5.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,),
                                    child: Text(
                                      S.of(context).price_details,
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0, right: 15, left: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).subtotal,
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        Helper.getPrice(couponApplied && _con.appliedCouponDiscountPrice != 0.0? (_con.subTotal+_con.appliedCouponDiscountPrice): _con.subTotal, context,
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: '0')
                                      ],
                                    ),
                                  ),

                                  Visibility(
                                    visible: couponApplied && _con.appliedCouponDiscountPrice != 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
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

                                  Visibility(
                                    // visible: _con.deliveryFee != 0.0,
                                    visible: true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              S.of(context).delivery_fee,
                                              style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                            ),
                                          ),
                                          if(_con.deliveryFee != 0.0)
                                            if (Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts))
                                            Helper.getPrice(_con.carts[0].product.market.deliveryFee, context,
                                                style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: S.of(context).free)
                                            else
                                            Helper.getPrice(0, context,
                                                style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: S.of(context).free)
                                          else
                                            Text("Free", style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            '${S.of(context).tax} (${_con.carts[0].product.market.defaultTax}%)',
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        Helper.getPrice(_con.taxAmount, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Divider(
                                      color: Theme.of(context).dividerColor.withOpacity(0.8),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).total,
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                          Helper.getPrice(_con.total, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: 'Free')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
