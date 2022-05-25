import 'dart:ui';

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/OptionItemWidget.dart';
import '../models/product.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class DropdownDialogScreen extends StatefulWidget{

  final Product product;
  final VoidCallback onChanged_;

  DropdownDialogScreen({Key key, this.product, this.onChanged_}) : super(key: key);

  @override
  DropdownDialogScreenState createState() => DropdownDialogScreenState();
  
}
class DropdownDialogScreenState extends StateMVC<DropdownDialogScreen>{

  ProductController _con;

  DropdownDialogScreenState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForProduct(productId: widget.product.id);
    _con.listenForCart();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 35,
      backgroundColor: Colors.transparent,
      child: dropDownBox(context),
    );
  }

  dropDownBox(context) {
   return Stack(
     children: [
       Container(
         height: MediaQuery.of(context).size.height*0.45,
         padding: EdgeInsets.only(top: 15, bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
          S.of(context).available_quantities,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
                child: Text(
                  widget.product.name +" - " + widget.product.market.name,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),

              widget.product.optionGroups?.isEmpty ?? false
                  ? CircularLoadingWidget(height: 100)
                  : Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 15,bottom: 15,right: 20,left: 20),
                      itemBuilder: (context, optionIndex) {
                        var optionGroup = widget.product.optionGroups.elementAt(0);
                        return OptionItemWidget(
                          option: widget.product.options.where((option) => option.optionGroupId == optionGroup.id).elementAt(optionIndex),
                          onChanged: () => updateItem(optionIndex),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      itemCount: widget.product.options.where((option) => option.optionGroupId ==  widget.product.optionGroups.elementAt(0).id).length,
                      primary: false,
                      shrinkWrap: true,
                    ),
                  ),
            ],
          ),
        ),
       Positioned(
         right: 0,
         child: new IconButton(
           splashColor: Colors.transparent,
           highlightColor: Colors.transparent,
           icon: Icon(Icons.close, color: Theme.of(context).hintColor),
           onPressed: () => {
             Navigator.of(context).pop(""),
           },
         ),
       ),

     ],
   );
  }

  void updateItem(int index) {
    setState(() {
      for(int i =0;i<widget.product.options.length;i++){
        print(widget.product.options.elementAt(i).checked);
        widget.product.options..elementAt(i).checked = false;
      }
      widget.product.options..elementAt(index).checked  = true;
      widget.onChanged_();
    });
  }
  
}