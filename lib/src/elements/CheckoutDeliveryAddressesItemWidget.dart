import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';
import 'DeliveryAddressBottomSheetWidget.dart';

// ignore: must_be_immutable
class CheckoutDeliveryAddressesItemWidget extends StatelessWidget {
  String heroTag;
  model.Address address;
  PaymentMethod paymentMethod;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onLongPress;
  ValueChanged<model.Address> onDismissed;
  int selectedPlan;
  bool deliveryAvailable;

  final VoidCallback changeAddress;

  CheckoutDeliveryAddressesItemWidget({Key key, this.address, this.onPressed, this.onLongPress, this.onDismissed, this.paymentMethod, this.selectedPlan, this.changeAddress, this.deliveryAvailable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onDismissed != null) {
      return Dismissible(
        key: Key(address.id),
        onDismissed: (direction) {
          this.onDismissed(address);
        },
        child: buildItem(context),
      );
    } else {
      return buildItem(context);
    }
  }

  InkWell buildItem(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      // onTap: () {
      //   this.onPressed(address);
      // },
      // onLongPress: () {
      //   this.onLongPress(address);
      // },
      child: Column(
        children: [
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              if(selectedPlan == 0){
                this.onPressed(address);
              }
            },
            onLongPress: () {
              if(selectedPlan == 0){
                this.onLongPress(address);
              }
            },
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 10,right: 8),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: deliveryAvailable?Theme.of(context).primaryColor.withOpacity(0.9):Theme.of(context).primaryColor.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Stack(
                  //   alignment: AlignmentDirectional.center,
                  //   children: <Widget>[
                  //     Container(
                  //       height: 40,
                  //       width: 40,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.all(Radius.circular(8)),
                  //           color:
                  //               (address?.isDefault ?? false) || (paymentMethod?.selected ?? false) ? Theme.of(context).accentColor : Theme.of(context).focusColor),
                  //       child: Icon(
                  //         (paymentMethod?.selected ?? false) ? Icons.check : Icons.place_outlined,
                  //         color: Theme.of(context).primaryColor,
                  //         size: 24,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Radio(
                    value: 1,
                    groupValue: selectedPlan,
                    activeColor: Theme.of(context).buttonColor,
                    onChanged: (Object value) {
                    },
                  ),
                  SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delivery",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: deliveryAvailable?Theme.of(context).textTheme.subtitle1:Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor.withOpacity(0.6))),
                      ),

                      Visibility(
                        visible: !deliveryAvailable,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            S.of(context).deliveryMethodNotAllowed,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).buttonColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Flexible(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: <Widget>[
                  //             address?.description != null
                  //                 ? Text(
                  //               address.description,
                  //               overflow: TextOverflow.fade,
                  //               softWrap: false,
                  //               style: Theme.of(context).textTheme.subtitle1,
                  //             )
                  //                 : SizedBox(height: 0),
                  //             Text(
                  //               address?.address ?? S.of(context).unknown,
                  //               overflow: TextOverflow.ellipsis,
                  //               maxLines: 3,
                  //               style: deliveryAvailable?address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1:Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor.withOpacity(0.6))),
                  //             ),
                  //
                  //             Visibility(
                  //               visible: !deliveryAvailable,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(top: 5.0),
                  //                 child: Text(
                  //                   S.of(context).deliveryMethodNotAllowed,
                  //                   maxLines: 3,
                  //                   overflow: TextOverflow.ellipsis,
                  //                   style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).buttonColor)),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //
                  // Visibility(
                  //   visible: deliveryAvailable,
                  //   child: InkWell(
                  //     onTap: (){
                  //       this.changeAddress();
                  //     },
                  //     child: Text(
                  //       "CHANGE",
                  //       overflow: TextOverflow.fade,
                  //       softWrap: false,
                  //       style: TextStyle(color: Theme.of(context).buttonColor),
                  //     ),
                  //   ),
                  // )

                  // new IconButton(
                  //   splashColor: Colors.transparent,
                  //   highlightColor: Colors.transparent,
                  //   icon: Icon(Icons.add_circle_rounded, color: Theme.of(context).hintColor),
                  //   onPressed: (){
                  //     this.changeAddress();
                  //   },
                  // ),

                  // Radio(
                  //   value: 1,
                  //   groupValue: selectedPlan,
                  //   activeColor: Theme.of(context).accentColor,
                  //   onChanged: (Object value) {
                  //     print(value);
                  //     selectedPlan = value ;
                  //   },
                  // )
                ],
              ),
            ),
          ),

          Visibility(
            visible: paymentMethod.selected || !deliveryAvailable,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 15,right: 15),
                margin: EdgeInsets.only(left: 30, right: 10),
                decoration: BoxDecoration(
                  color: deliveryAvailable?Theme.of(context).primaryColor.withOpacity(0.9):Theme.of(context).primaryColor.withOpacity(0.6),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Visibility(
                            visible: address?.description == null,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                               "My Address",
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),

                          address?.description != null
                              ? Text(
                            address.description,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                              : SizedBox(height: 0),
                          Text(
                            address?.address ?? S.of(context).unknown,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: deliveryAvailable?address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.caption:Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).hintColor.withOpacity(0.6))),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        this.changeAddress();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "CHANGE",
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(color: Theme.of(context).buttonColor),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
