import 'package:eighttoeightneeds/src/elements/CircularLoadingWidget.dart';
import 'package:eighttoeightneeds/src/models/address.dart';
import 'package:eighttoeightneeds/src/models/route_argument.dart';
import 'package:eighttoeightneeds/src/pages/all_categories.dart';
import 'package:eighttoeightneeds/src/repository/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsCarouselWidget.dart';
import '../elements/CaregoriesCarouselWidget.dart';
import '../elements/DeliveryAddressBottomSheetWidget.dart';
import '../elements/GridWidget.dart';
import '../elements/HomeSliderWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/ReviewsListWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Image.asset(
            'assets/img/icon_sort.png',
            color: Theme.of(context).hintColor,
            width: 18,
            height: 16,
          ),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              value.appName ?? S.of(context).home,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).highlightColor),
        ],
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: _con.refreshHome,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: List.generate(
                  settingsRepo.setting.value.homeSections.length, (index) {
                String _homeSection =
                    settingsRepo.setting.value.homeSections.elementAt(index);
                switch (_homeSection) {
                  case 'slider':
                    return HomeSliderWidget(slides: _con.slides);
                  case 'search':
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarWidget(
                        onClickFilter: (event) {
                          widget.parentScaffoldKey.currentState.openEndDrawer();
                        },
                      ),
                    );
                  case 'top_markets_heading':
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -3),
                        horizontalTitleGap: 2,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        leading: Icon(
                          Icons.place_outlined,
                          color: Theme.of(context).accentColor,
                          size: 28,
                        ),
                        title: InkWell(
                          onTap: () async {
                            if (currentUser.value.apiToken == null) {

                              LocationResult result = await showLocationPicker(
                                context,
                                setting.value.googleMapsKey,
                                initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0, deliveryAddress.value?.longitude ?? 0),
                                myLocationButtonEnabled: true,
                              );

                              if(result != null){
                                setState(() {
                                  settingsRepo.deliveryAddress.value = new Address.fromJSON({
                                    'address': result.address,
                                    'latitude': result.latLng.latitude,
                                    'longitude': result.latLng.longitude,
                                  });;
                                });
                                settingsRepo.deliveryAddress.notifyListeners();
                                _con.refreshHome();
                              }
                            } else {
                              var bottomSheetController = widget
                                  .parentScaffoldKey.currentState
                                  .showBottomSheet(
                                (context) => DeliveryAddressBottomSheetWidget(
                                    scaffoldKey: widget.parentScaffoldKey, onAddressSelection: () {
                                  _con.refreshHome();
                                    },),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                              );
                              bottomSheetController.closed.then((value) {
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                settingsRepo.deliveryAddress.value
                                            ?.description ==
                                        null
                                    ? S.of(context).delivery
                                    : settingsRepo
                                        .deliveryAddress.value?.description,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: settingsRepo.deliveryAddress.value
                                                ?.address ==
                                            null
                                        ? Theme.of(context).hintColor
                                        : Theme.of(context).accentColor),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Theme.of(context).accentColor,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                        subtitle: Visibility(
                          visible:
                              settingsRepo.deliveryAddress.value?.address !=
                                  null,
                          child: InkWell(
                            onTap: () async {
                              if (currentUser.value.apiToken == null) {
                                LocationResult result = await showLocationPicker(
                                  context,
                                  setting.value.googleMapsKey,
                                  initialCenter: LatLng(deliveryAddress.value?.latitude ?? 0, deliveryAddress.value?.longitude ?? 0),
                                  myLocationButtonEnabled: true,
                                );

                                if(result != null){
                                  setState(() {
                                    settingsRepo.deliveryAddress.value = new Address.fromJSON({
                                      'address': result.address,
                                      'latitude': result.latLng.latitude,
                                      'longitude': result.latLng.longitude,
                                    });;
                                  });
                                  settingsRepo.deliveryAddress.notifyListeners();
                                  _con.refreshHome();
                                }
                              } else {
                                var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
                                  (context) => DeliveryAddressBottomSheetWidget(
                                      scaffoldKey: widget.parentScaffoldKey, onAddressSelection: (){
                                    _con.refreshHome();
                                  },),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                  ),
                                );
                                bottomSheetController.closed.then((value) async{
                                });
                              }
                            },
                            child: Text(
                              settingsRepo.deliveryAddress.value?.address ==
                                      null
                                  ? ""
                                  : settingsRepo.deliveryAddress.value?.address,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ),
                        // trailing: InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       settingsRepo.deliveryAddress.value?.address = null;
                        //       settingsRepo.deliveryAddress.value?.description = null;
                        //     });
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.all(Radius.circular(5)),
                        //       color: settingsRepo.deliveryAddress.value?.address != null
                        //           ? Theme.of(context).focusColor.withOpacity(0.1)
                        //           : Theme.of(context).accentColor,
                        //     ),
                        //     child: Text(
                        //       S.of(context).pickup,
                        //       style: TextStyle(
                        //           color: settingsRepo.deliveryAddress.value?.address != null
                        //               ? Theme.of(context).hintColor
                        //               : Theme.of(context).primaryColor),
                        //     ),
                        //   ),
                        // ),
                      ),
                    );
                  case 'top_markets':
                    return CardsCarouselWidget(
                        marketsList: _con.topMarkets,
                        heroTag: 'home_top_markets');
                  case 'trending_week_heading':
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Visibility(
                        visible: _con.trendingProducts.isNotEmpty,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                '/ViewAllTrendingProduct',
                                arguments: widget.parentScaffoldKey);
                          },
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            title: Text(
                              S.of(context).trending_products,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  S.of(context).view_all,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  case 'trending_week':
                    return Visibility(
                        visible: _con.trendingProducts.isNotEmpty,
                        child: ProductsCarouselWidget(
                            productsList: _con.trendingProducts,
                            heroTag: 'home_product_carousel'));
                  case 'categories_heading':
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllCategories(
                                      parentScaffoldKey:
                                          widget.parentScaffoldKey)));
                        },
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          title: Text(
                            S.of(context).product_categories,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          trailing: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                S.of(context).view_all,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  case 'categories':
                    return CategoriesCarouselWidget(
                      categories: _con.categories,
                    );
                  case 'popular_heading':
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Visibility(
                        visible: _con.popularProducts.isNotEmpty,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                '/ViewAllPopularProduct',
                                arguments: widget.parentScaffoldKey);
                          },
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              S.of(context).most_popular,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            trailing: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  S.of(context).view_all,
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  case 'popular':
                    return Padding(
                      padding: const EdgeInsets.only(),
                      child: Visibility(
                        visible: _con.popularProducts.isNotEmpty,
                        child: GridWidget(
                          marketsList: _con.popularProducts,
                          heroTag: 'home_markets',
                        ),
                      ),
                    );
                  case 'recent_reviews_heading':
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        leading: Icon(
                          Icons.recent_actors_outlined,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).recent_reviews,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    );
                  case 'recent_reviews':
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ReviewsListWidget(reviewsList: _con.recentReviews),
                    );
                  case 'categorized_products':
                    return _con.categorizedProducts.isEmpty? CircularLoadingWidget(height: 150)
                    :ListView.builder(
                      shrinkWrap: true,
                      itemCount: _con.categorizedProducts.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id:  _con.categorizedProducts[index].id, param:  _con.categorizedProducts[index].category_name), );
                                },
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                  title: Text(
                                    _con.categorizedProducts[index].category_name,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  trailing: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(
                                        S.of(context).view_all,
                                        style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 15,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ProductsCarouselWidget(
                                productsList: _con.categorizedProducts[index].product,
                                heroTag: 'home_categorized_product'),
                          ],
                        );
                      },
                    );
                  default:
                    return SizedBox(height: 0);
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
