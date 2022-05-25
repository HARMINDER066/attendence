import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class PickUpMethodItem extends StatefulWidget {
  PaymentMethod paymentMethod;
  ValueChanged<PaymentMethod> onPressed;
  String marketAddress;
  String marketName;
  int selectedPlan;
  final VoidCallback onSelection;

  PickUpMethodItem({Key key, this.paymentMethod, this.onPressed, this.marketAddress, this.selectedPlan, this.marketName, this.onSelection}) : super(key: key);

  @override
  _PickUpMethodItemState createState() => _PickUpMethodItemState();
}

class _PickUpMethodItemState extends State<PickUpMethodItem> {
  String heroTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: Theme.of(context).accentColor,
          focusColor: Theme.of(context).accentColor,
          highlightColor: Theme.of(context).primaryColor,
          onTap: () {

            if(widget.selectedPlan == 1){
              this.widget.onSelection();
              this.widget.onPressed(widget.paymentMethod);
            }

          },
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                // Stack(
                //   alignment: AlignmentDirectional.center,
                //   children: <Widget>[
                //     Container(
                //       height: 40,
                //       width: 40,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(8)),
                //         image: DecorationImage(image: AssetImage(widget.paymentMethod.logo), fit: BoxFit.fill),
                //       ),
                //     ),
                //     Container(
                //       height: widget.paymentMethod.selected ? 40 : 0,
                //       width: widget.paymentMethod.selected ? 40 : 0,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(Radius.circular(8)),
                //         color: Theme.of(context).accentColor.withOpacity(this.widget.paymentMethod.selected ? 0.74 : 0),
                //       ),
                //       child: Icon(
                //         Icons.check,
                //         size: this.widget.paymentMethod.selected ? 24 : 0,
                //         color: Theme.of(context).primaryColor.withOpacity(widget.paymentMethod.selected ? 0.9 : 0),
                //       ),
                //     ),
                //   ],
                // ),

               Radio(
                  value:0,
                  groupValue: widget.selectedPlan,
                  activeColor: Theme.of(context).buttonColor,
                  onChanged: (Object value) {
                    // widget.selectedPlan = 0;
                    this.widget.onSelection();
                    this.widget.onPressed(widget.paymentMethod);
                    setState(() {
                    });
                  },
                ),
                SizedBox(width: 10),
                Text(
                  widget.paymentMethod.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                // Flexible(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: <Widget>[
                //       Expanded(
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: <Widget>[
                //             Text(
                //               widget.paymentMethod.name,
                //               overflow: TextOverflow.ellipsis,
                //               maxLines: 2,
                //               style: Theme.of(context).textTheme.subtitle1,
                //             ),
                //             // Padding(
                //             //   padding: const EdgeInsets.only(top: 5.0),
                //             //   child: Text(
                //             //     widget.paymentMethod.selected?widget.marketAddress:widget.paymentMethod.description,
                //             //     style: Theme.of(context).textTheme.caption,
                //             //   ),
                //             // ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),

        Visibility(
          visible:widget.paymentMethod.selected,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
              margin: EdgeInsets.only(left: 30, right: 10),
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
                  Text(
                    widget.marketName,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(widget.marketAddress,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
