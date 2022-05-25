import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> with TickerProviderStateMixin {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
    loadData();
  }

  void loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          if(settingsRepo.deliveryAddress.value.isUnknown()){
            Navigator.of(context).pushReplacementNamed('/SetDeliveryLocation');
          }else{
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          }

        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width*1,
        height: MediaQuery.of(context).size.height*1,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/img_bg_splash.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.12),
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                child:  CircularProgressIndicator(
                  valueColor: animationController
                      .drive(ColorTween(begin: Colors.deepOrange, end: Colors.redAccent)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }
}
