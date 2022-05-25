import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/map_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';

class MapWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MapWidget({Key key, this.routeArgument, this.parentScaffoldKey}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  MapController _con;

  _MapWidgetState() : super(MapController()) {
    _con = controller;
  }

  @override
  void initState() {

    // _con.goCurrentLocation();

    _con.currentMarket = widget.routeArgument?.param as Market;
    if (_con.currentMarket?.latitude != null) {
      // user select a market
      _con.getMarketLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: _con.currentMarket?.latitude == null
            ? new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Image.asset('assets/img/icon_sort.png', color: Theme.of(context).hintColor, width: 18, height: 16,),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        )
            : IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
                icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 2),
              ),
        title: Text(
          S.of(context).maps_explorer,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
              size: 28,
            ),
            onPressed: () {
              _con.goCurrentLocation();
            },
          ),
          Container(
              width: 60,
              child: new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor)),
          // IconButton(
          //   icon: Icon(
          //     Icons.filter_list,
          //     color: Theme.of(context).hintColor,
          //   ),
          //   onPressed: () {
          //     widget.parentScaffoldKey.currentState.openEndDrawer();
          //   },
          // ),
        ],
      ),
      body: Stack(
//        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
          _con.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              :
          GoogleMap(
                  mapToolbarEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: _con.cameraPosition,
                  markers: Set.from(_con.allMarkers),
                  onMapCreated: (GoogleMapController controller) {
                    _con.mapController.complete(controller);
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _con.cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    _con.getMarketsOfArea();
                  },
                  polylines: _con.polylines,
                ),
          CardsCarouselWidget(
            marketsList: _con.topMarkets,
            heroTag: 'map_markets',
          ),
        ],
      ),
    );
  }
}
