import 'package:eighttoeightneeds/src/helpers/checkbox_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';

class CheckoutConfirmAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Address address;
  ValueChanged<Address> onChanged;

  CheckoutConfirmAddressBottomSheetWidget({Key key, this.scaffoldKey, this.address, this.onChanged}) : super(key: key);

  @override
  _CheckoutConfirmAddressBottomSheetWidgetState createState() => _CheckoutConfirmAddressBottomSheetWidgetState();
}

class _CheckoutConfirmAddressBottomSheetWidgetState extends StateMVC<CheckoutConfirmAddressBottomSheetWidget> {
  DeliveryAddressesController _con;

  _CheckoutConfirmAddressBottomSheetWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  GlobalKey<FormState> _deliveryAddressFormKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        key: _con.scaffoldKey,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.4), blurRadius: 30, offset: Offset(0, -30)),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.place_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            S.of(context).add_delivery_address,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: _deliveryAddressFormKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: new TextFormField(
                              style: TextStyle(color: Theme.of(context).hintColor),
                              keyboardType: TextInputType.text,
                              decoration: getInputDecoration(hintText: S.of(context).hint_full_address, labelText: S.of(context).full_address),
                              initialValue: widget.address.address?.isNotEmpty ?? false ? widget.address.address : null,
                              validator: (input) => input.trim().length == 0 ? S.of(context).notValidAddress : null,
                              onSaved: (input) => widget.address.address = input,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: new TextFormField(
                              style: TextStyle(color: Theme.of(context).hintColor),
                              keyboardType: TextInputType.text,
                              decoration: getInputDecoration(hintText: S.of(context).hint_floor, labelText: S.of(context).floor),
                              initialValue:  null,
                              validator: (input) => input.trim().length == 0 ? S.of(context).floor_validation : null,
                              onSaved: (input) {
                                widget.address.address =  input==""?"":input+ ", "+widget.address.address;
                              }
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: new TextFormField(
                              style: TextStyle(color: Theme.of(context).hintColor),
                              keyboardType: TextInputType.text,
                              decoration: getInputDecoration(hintText: S.of(context).hint_tag_location, labelText: S.of(context).tag_location),
                              initialValue:  widget.address.description?.isNotEmpty ?? false ? widget.address.description : null,
                              validator: (input) => input.trim().length == 0 ? S.of(context).tag_location : null,
                              onSaved:  (input) => widget.address.description = input,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: CheckboxFormField(
                              context: context,
                              initialValue: widget.address.isDefault ?? false,
                              onSaved: (input) => widget.address.isDefault = input,
                              title: Text(S.of(context).default_address),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        // MaterialButton(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: Text(
                        //     S.of(context).cancel,
                        //     style: TextStyle(color: Theme.of(context).hintColor),
                        //   ),
                        // ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          elevation: 0,
                          onPressed: _submit,
                          disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                          color:  Theme.of(context).buttonColor,
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0) ),
                          child: Text("Save Address",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        // MaterialButton(
                        //   splashColor: Colors.transparent,
                        //   highlightColor: Colors.transparent,
                        //   onPressed: _submit,
                        //   child: Text(
                        //     S.of(context).save,
                        //     style: TextStyle(color: Theme.of(context).accentColor),
                        //   ),
                        // ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              )
            ),
            Container(
              height: 30,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: config.App(context).appWidth(42)),
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.05),
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              ),
              child: Container(
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).focusColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(3),
                ),
                //child: SizedBox(height: 1,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration getInputDecoration({String hintText, String labelText}) {
    return new InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).focusColor),
      ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor.withOpacity(0.2))),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).hintColor)),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: Theme.of(context).textTheme.bodyText2.merge(
        TextStyle(color: Theme.of(context).hintColor),
      ),
    );
  }

  void _submit() {
    if (_deliveryAddressFormKey.currentState.validate()) {
      _deliveryAddressFormKey.currentState.save();
      widget.onChanged(widget.address);
      Navigator.pop(context);
    }
  }
}
