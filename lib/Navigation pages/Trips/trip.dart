import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:eighttoeightneeds/Global/global.dart';
import 'package:eighttoeightneeds/Navigation%20pages/Trips/incoming_ride.dart';

class TripPage extends StatefulWidget {
  const TripPage({Key key}) : super(key: key);

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 2), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const IncomingRide()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/map_screen.png"))),
            ),

            Positioned(
              bottom: screenSize.height * 0.0175,
              right: 16,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 2),
                              color: Colors.grey.shade300)
                        ]),
                    child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shield,
                          color: kPinkColor.withOpacity(0.6),
                        )),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPinkColor,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 2),
                              color: Colors.grey.shade300)
                        ]),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          EvaIcons.powerOutline,
                          color: Colors.white,
                        )),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 2),
                              color: Colors.grey.shade300)
                        ]),
                    child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.location_off,
                          color: kPinkColor.withOpacity(0.6),
                        )),
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
