import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/delivery_addresses_controller.dart';
import '../helpers/app_config.dart' as config;
import '../models/address.dart';
import '../repository/settings_repository.dart';
import 'CheckoutConfirmAddressBottomSheetWidget.dart';

class CheckoutDeliveryAddressBottomSheetWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback onAddressSelection;

  CheckoutDeliveryAddressBottomSheetWidget({Key key, this.scaffoldKey, this.onAddressSelection}) : super(key: key);

  @override
  _CheckoutDeliveryAddressBottomSheetWidgetState createState() => _CheckoutDeliveryAddressBottomSheetWidgetState();
}

class _CheckoutDeliveryAddressBottomSheetWidgetState extends StateMVC<CheckoutDeliveryAddressBottomSheetWidget> {
  DeliveryAddressesController _con;

  _CheckoutDeliveryAddressBottomSheetWidgetState() : super(DeliveryAddressesController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _con.scaffoldKey,
      height: 350,
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
            padding: const EdgeInsets.only(top: 30),
            child: ListView(
              padding: EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    LocationResult result = await showLocationPicker(
                      context,
                      setting.value.googleMapsKey,
                      initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0, deliveryAddress.value?.longitude ?? 0),
                      //automaticallyAnimateToCurrentLocation: true,
                      //mapStylePath: 'assets/mapStyle.json',
                      myLocationButtonEnabled: true,
                      //resultCardAlignment: Alignment.bottomCenter,
                    );
                    print("result--> ${result.address}");

                    // _con.addAddress(new Address.fromJSON({
                    //   'address': result.address,
                    //   'latitude': result.latLng.latitude,
                    //   'longitude': result.latLng.longitude,
                    // }));

                    var bottomSheetController = await showModalBottomSheet(
                      isDismissible: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      builder: (BuildContext bc) {
                        return CheckoutConfirmAddressBottomSheetWidget(scaffoldKey: _con.scaffoldKey, address: new Address.fromJSON({
                          'address': result.address,
                          'latitude': result.latLng.latitude,
                          'longitude': result.latLng.longitude,
                        }),
                        onChanged: (Address _address){
                          _con.addAddress(new Address.fromJSON({
                            'address': _address.address,
                            'latitude': result.latLng.latitude,
                            'longitude': result.latLng.longitude,
                          }));
                        },);
                      },
                    );

                    // Navigator.of(widget.scaffoldKey.currentContext).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).focusColor),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 22,
                        ),
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
                                  Text(
                                    S.of(context).add_new_delivery_address,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Theme.of(context).focusColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(height: 25),
                Visibility(
                  visible: false,
                  child: InkWell(
                    onTap: () {
                      _con.changeDeliveryAddressToCurrentLocation().then((value) {
                        widget.onAddressSelection();
                        Navigator.of(widget.scaffoldKey.currentContext).pop();
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).accentColor),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 22,
                          ),
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
                                    Text(
                                      S.of(context).current_location,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.keyboard_arrow_right,
                                color: Theme.of(context).focusColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _con.addresses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 25);
                  },
                  itemBuilder: (context, index) {
//                return DeliveryAddressesItemWidget(
//                  address: _con.addresses.elementAt(index),
//                  onPressed: (Address _address) {
//                    _con.chooseDeliveryAddress(_address);
//                  },
//                  onLongPress: (Address _address) {
//                    DeliveryAddressDialog(
//                      context: context,
//                      address: _address,
//                      onChanged: (Address _address) {
//                        _con.updateAddress(_address);
//                      },
//                    );
//                  },
//                  onDismissed: (Address _address) {
//                    _con.removeDeliveryAddress(_address);
//                  },
//                );
                    return InkWell(
                      onTap: () {

                        _con.changeDeliveryAddress(_con.addresses.elementAt(index)).then((value) {
                          widget.onAddressSelection();
                          Navigator.of(widget.scaffoldKey.currentContext).pop();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Theme.of(context).focusColor),
                            child: Icon(
                              Icons.place_outlined,
                              color: Theme.of(context).primaryColor,
                              size: 22,
                            ),
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
                                      Text(
                                        _con.addresses.elementAt(index).address == null? "":_con.addresses.elementAt(index).address,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Theme.of(context).focusColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
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
    );
  }
}
