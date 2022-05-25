import 'dart:async';

import 'package:eighttoeightneeds/src/elements/CheckoutDeliveryAddressBottomSheetWidget.dart';
import 'package:eighttoeightneeds/src/elements/CheckoutDeliveryAddressesItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_pickup_controller.dart';
import '../elements/DeliveryAddressDialog.dart';
import '../elements/PickUpMethodItemWidget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';

class DeliveryPickupWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  DeliveryPickupWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _DeliveryPickupWidgetState createState() => _DeliveryPickupWidgetState();
}

class _DeliveryPickupWidgetState extends StateMVC<DeliveryPickupWidget> {
  DeliveryPickupController _con;

  _DeliveryPickupWidgetState() : super(DeliveryPickupController()) {
    _con = controller;
  }

  int _selectedType = 0;

  bool loading = true;

  @override
  void initState() {
    setState(() {_con.selectedPickup=true;});
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          loading = false;
          if (_con.list != null) {
            _con.getPickUpMethod().selected = true;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_con.list == null) {
      _con.list = new PaymentMethodList(context);
    }
    return Scaffold(
      key: _con.scaffoldKey,
      // bottomNavigationBar: CartBottomDetailsWidget(con: _con),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          S.of(context).delivery_or_pickup,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      bottomNavigationBar: Visibility(
        visible: _con.carts.isNotEmpty,
        child: Container(
          child: MaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              if (_con.list.pickupList.elementAt(0).selected || _con.list.pickupList.elementAt(1).selected) {
                _con.goCheckout(context);
              } else {
                // ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                //   content: Text(S.of(context).select_delivery_or_pickup),
                // ));
              }
            },
            disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
            padding: EdgeInsets.symmetric(vertical: 14),
            color: _con.carts.isNotEmpty &&
                    !_con.carts[0].product.market.closed &&
                    (_con.list.pickupList.elementAt(0).selected || _con.list.pickupList.elementAt(1).selected)
                ? Theme.of(context).buttonColor
                : Theme.of(context).focusColor.withOpacity(0.6),
            child: Text(
              S.of(context).checkout,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            loading
                ? SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                    ),
                  )
                : SizedBox(),
            Visibility(
              visible:false,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.domain,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    S.of(context).delivery_or_pickup,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  subtitle: Text(
                    S.of(context).select_delivery_pickup,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _con.carts.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: PickUpMethodItem(
                    selectedPlan: _selectedType,
                    marketName: _con.carts.isNotEmpty ? _con.carts[0].product.market.name : "",
                    marketAddress: _con.carts.isNotEmpty ? _con.carts[0].product.market.address : "",
                    paymentMethod: _con.getPickUpMethod(),
                    onPressed: (paymentMethod) {
                      _con.togglePickUp();
                    },
                  onSelection: (){
                    _selectedType = 0;
                    _con.selectedPickup = true;
                    _con.calculateSubtotal();
                    setState(() { });
                  },
                    ),
              ),
            ),
            Visibility(
              visible: _con.carts.isNotEmpty,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 20, right: 10, bottom: 10),
                    child: Visibility(
                      visible: false,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.map_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).delivery,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)
                            ? Text(
                                S.of(context).click_to_confirm_your_address_and_pay_or_long_press,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              )
                            : Text(
                                S.of(context).deliveryMethodNotAllowed,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                      ),
                    ),
                  ),
                  // _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts) ?
                  CheckoutDeliveryAddressesItemWidget(
                    selectedPlan: _selectedType,
                    deliveryAvailable: _con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts),
                    paymentMethod: _con.getDeliveryMethod(),
                    address: _con.deliveryAddress,
                    onPressed: (Address _address) async {

                      if (_con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)) {

                        print("deliveryAddress==>${_con.deliveryAddress.id}");
                        print("deliveryAddress==>${_con.addresses.length}");
                        if (_con.deliveryAddress.id == null || _con.deliveryAddress.id == 'null' || _con.addresses.length==0) {
                          // DeliveryAddressDialog(
                          //   context: context,
                          //   address: _address,
                          //   onChanged: (Address _address) {
                          //     _con.addAddress(_address);
                          //   },
                          // );
                          
                            var bottomSheetController = await showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              builder: (BuildContext bc) {
                                return CheckoutDeliveryAddressBottomSheetWidget(scaffoldKey: _con.scaffoldKey, onAddressSelection: (){
                                  _con.listenForDeliveryAddress();
                                  // _selectedType = 1 ;
                                  // _con.toggleDelivery();
                                  if (_con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)){
                                    _selectedType = 1 ;
                                    _con.selectedPickup = false;
                                    _con.calculateSubtotal();
                                    _con.toggleDelivery();
                                  }else{
                                    _selectedType = 0;
                                    _con.selectedPickup = true;
                                    _con.calculateSubtotal();
                                    _con.togglePickUp();
                                  }
                                  setState(() {});
                                },);
                              },
                            );

                        } else {
                          _selectedType = 1 ;
                          _con.selectedPickup = false;
                          _con.calculateSubtotal();
                          setState(() { });
                          _con.toggleDelivery();
                        }
                      }
                    },
                    onLongPress: (Address _address) {
                      // if (_con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)) {
                      //   DeliveryAddressDialog(
                      //     context: context,
                      //     address: _address,
                      //     onChanged: (Address _address) {
                      //       _con.updateAddress(_address);
                      //     },
                      //   );
                      // }
                    },
                    changeAddress: () async {
                      // if (_con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)){
                        var bottomSheetController = await showModalBottomSheet(
                          isDismissible: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          ),
                          builder: (BuildContext bc) {
                            return CheckoutDeliveryAddressBottomSheetWidget(scaffoldKey: _con.scaffoldKey, onAddressSelection: (){
                              _con.listenForDeliveryAddress();

                              if (_con.carts.isNotEmpty && Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts)){
                                if(_selectedType != 1){
                                  _selectedType = 1 ;
                                  _con.selectedPickup = false;
                                  _con.calculateSubtotal();
                                  _con.toggleDelivery();
                                }
                              }
                              else{
                                if(_selectedType != 0){
                                  _selectedType = 0;
                                  _con.selectedPickup = true;
                                  _con.calculateSubtotal();
                                  _con.togglePickUp();
                                }
                              }
                              setState(() {});
                            },);
                          },
                        );
                      // }
                    },
                  )
                  // : NotDeliverableAddressesItemWidget(),
                ],
              ),
            ),
            SizedBox(height: 20),
            _con.carts.isEmpty
                ? SizedBox(height: 0)
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                ),
                              ),
                              Helper.getPrice(_con.appliedCouponDiscountPrice != 0.0?(_con.subTotal+_con.appliedCouponDiscountPrice):_con.subTotal, context,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                  zeroPlaceholder: '0')
                            ],
                          ),
                        ),

                        Visibility(
                          visible:_con.appliedCouponDiscountPrice != 0.0,
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
                          // visible: _con.deliveryFee != 0.0 && _selectedType !=0,
                          visible: _selectedType !=0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    S.of(context).delivery_fee,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                  ),
                                ),
                                if(_con.deliveryFee != 0.0)
                                  if (Helper.canDelivery(_con.carts[0].product.market, carts: _con.carts))
                                  Helper.getPrice(_con.carts[0].product.market.deliveryFee, context,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                      zeroPlaceholder: S.of(context).free)
                                  else
                                  Helper.getPrice(0, context,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                      zeroPlaceholder: S.of(context).free)
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                ),
                              ),
                              Helper.getPrice(
                                _con.taxAmount,
                                context,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                              )
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                ),
                              ),
                             Helper.getPrice( _selectedType==0?((_con.total)-(_con.deliveryFee)): _con.total, context,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                  zeroPlaceholder: 'Free')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
