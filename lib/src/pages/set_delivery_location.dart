import 'package:eighttoeightneeds/generated/l10n.dart';
import 'package:eighttoeightneeds/src/controllers/home_controller.dart';
import 'package:eighttoeightneeds/src/helpers/helper.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class SetDeliveryLocation extends StatefulWidget {
  const SetDeliveryLocation({Key key}) : super(key: key);

  @override
  _SetDeliveryLocationState createState() => _SetDeliveryLocationState();
}

class _SetDeliveryLocationState extends StateMVC<SetDeliveryLocation> {
  HomeController _con;

  _SetDeliveryLocationState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg_set_delivery_location.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Image.asset('assets/img/icon_set_del_location.png', width: 180,height: 180,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(visible: settingsRepo.deliveryAddress.value?.address != null , child: Image.asset('assets/img/icon_location_delivery.png',width: 20,height: 20,)),
                      Visibility(
                        visible: settingsRepo.deliveryAddress.value?.address != null ,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                           "Delivering To",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: settingsRepo.deliveryAddress.value?.address != null ,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 30, right: 30),
                    child: Text(
                      settingsRepo.deliveryAddress.value?.address == null?"": settingsRepo.deliveryAddress.value?.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).hintColor, fontSize: 16)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.65,
                    margin:
                    EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.white)),
                    child: TextButton(
                      onPressed: () {

                        checkSMSPermission();
                      },
                      child: Text(
                        settingsRepo.deliveryAddress.value?.address == null ? S.of(context).set_delivery_location : "Finish",
                        style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void checkSMSPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.location.request();
      print("permissionStatus ${permissionStatus.isGranted}");
    } else if(status.isPermanentlyDenied){
      openAppSettings();
    }else {
      if (settingsRepo.deliveryAddress.value?.address == null) {
        _con.requestForInitialCurrentLocation(context);
      } else {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      }
    }
  }
}
