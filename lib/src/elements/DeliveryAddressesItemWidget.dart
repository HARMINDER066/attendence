import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../models/address.dart' as model;
import '../models/payment_method.dart';

// ignore: must_be_immutable
class DeliveryAddressesItemWidget extends StatelessWidget {
  String heroTag;
  model.Address address;
  PaymentMethod paymentMethod;
  ValueChanged<model.Address> onPressed;
  ValueChanged<model.Address> onLongPress;
  ValueChanged<model.Address> onDismissed;
  int selectedPlan;

  DeliveryAddressesItemWidget({Key key, this.address, this.onPressed, this.onLongPress, this.onDismissed, this.paymentMethod, this.selectedPlan}) : super(key: key);

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
      onTap: () {
        this.onPressed(address);
      },
      onLongPress: () {
        this.onLongPress(address);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15,right: 5, top: 15,bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 10),
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
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color:
                          (address?.isDefault ?? false) || (paymentMethod?.selected ?? false) ? Theme.of(context).accentColor : Theme.of(context).focusColor),
                  child: Icon(
                    (paymentMethod?.selected ?? false) ? Icons.check : Icons.place_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                          maxLines: 2,
                          style: address?.description != null ? Theme.of(context).textTheme.caption : Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<int>(
              onSelected: (item) => handleClick(item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(value: 0, child: Text('Delete', style:Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontWeight: FontWeight.w400)))),
              ],
            ),
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
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        this.onDismissed(address);
        break;
    }
  }
}
