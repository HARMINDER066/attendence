import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/l10n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/GalleryCarouselWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../helpers/helper.dart';
import '../models/market.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class MarketWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MarketWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);

  @override
  _MarketWidgetState createState() {
    return _MarketWidgetState();
  }
}

class _MarketWidgetState extends StateMVC<MarketWidget> {
  MarketController _con;

  _MarketWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.market = widget.routeArgument.param as Market;
    _con.listenForGalleries(_con.market.id);
    _con.listenForFeaturedProducts(_con.market.id);
    _con.listenForMarketReviews(id: _con.market.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: new Image.asset('assets/img/icon_sort.png', color: Theme.of(context).hintColor, width: 18, height: 16,),
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
                S.of(context).shop_details,
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
              );
            },
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
          ],
          bottom: PreferredSize(
              child: Container(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                height: 0.5,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshMarket,
          child: _con.market == null
              ? CircularLoadingWidget(height: 200)
              : SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 25),
                  child: Column(

            children: [
              Container(
                  margin: EdgeInsets.only( top: 15, bottom: 20),
                  height: 220,
                  width: MediaQuery.of(context).size.width*1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Hero(
                    tag: (widget?.routeArgument?.heroTag ?? '') + _con.market.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: _con.market.image.url,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                  ),
              ),
              Wrap(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _con.market?.name ?? '',
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(color: _con.market.closed ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(24)),
                          child: _con.market.closed
                              ? Text(
                            S.of(context).closed,
                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                          )
                              : Text(
                            S.of(context).open,
                            style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        // SizedBox(
                        //   height: 32,
                        //   child: Chip(
                        //     padding: EdgeInsets.all(0),
                        //     label: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: <Widget>[
                        //         Text(_con.market.rate, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
                        //         Icon(
                        //           Icons.star_border,
                        //           color: Theme.of(context).primaryColor,
                        //           size: 16,
                        //         ),
                        //       ],
                        //     ),
                        //     backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                        //     shape: StadiumBorder(),
                        //   ),
                        // ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        Helper.getDistance(_con.market.distance, Helper.of(context).trans(setting.value.distanceUnit)),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15,),
                      child: Helper.applyHtml(context, _con.market.description),
                    ),
                    ImageThumbCarouselWidget(galleriesList: _con.galleries),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        S.of(context).information,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Helper.applyHtml(context, _con.market.information),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    //   margin: const EdgeInsets.symmetric(vertical: 5),
                    //   color: Theme.of(context).primaryColor,
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Text(
                    //           currentUser.value.apiToken != null ? S.of(context).forMoreDetailsPleaseChatWithOurManagers : S.of(context).signinToChatWithOurManagers,
                    //           overflow: TextOverflow.ellipsis,
                    //           maxLines: 3,
                    //           style: Theme.of(context).textTheme.bodyText1,
                    //         ),
                    //       ),
                    //       SizedBox(width: 10),
                    //
                    //       // message
                    //       SizedBox(
                    //         width: 42,
                    //         height: 42,
                    //         child: MaterialButton(
                    //           elevation: 0,
                    //           padding: EdgeInsets.all(0),
                    //           disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
                    //           onPressed: currentUser.value.apiToken != null
                    //               ? () {
                    //             Navigator.of(context).pushNamed('/Chat',
                    //                 arguments: RouteArgument(
                    //                     param: new Conversation(
                    //                         _con.market.users.map((e) {
                    //                           e.image = _con.market.image;
                    //                           return e;
                    //                         }).toList(),
                    //                         name: _con.market.name)));
                    //           }
                    //               : null,
                    //           child: Icon(
                    //             Icons.chat_outlined,
                    //             color: Theme.of(context).primaryColor,
                    //             size: 24,
                    //           ),
                    //           color: Theme.of(context).accentColor.withOpacity(0.9),
                    //           shape: StadiumBorder(),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 1, offset: Offset(0, 1)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor.withOpacity(0.9),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: MaterialButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  launch("tel:${_con.market.mobile}");
                                },
                                child: Icon(
                                  Icons.call_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 24,
                                ),

                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: _con.market.phone != null,
                                  child: Text(
                                    '${_con.market.phone??""}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Visibility(
                                  visible:  _con.market.mobile != null,
                                  child: Text(
                                    '${_con.market.mobile??""}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 1, offset: Offset(0, 1)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor.withOpacity(0.9),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: MaterialButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '1', param: _con.market));
                                },
                                child: Icon(
                                  Icons.directions_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _con.market.address ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _con.featuredProducts.isEmpty
                        ? SizedBox(height: 0)
                        : Padding(
                      padding: const EdgeInsets.only(top:  15),
                      child:Text(
                        S.of(context).featured_products,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    _con.featuredProducts.isEmpty
                        ? SizedBox(height: 0)
                        : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.featuredProducts.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return ProductItemWidget(
                          heroTag: 'details_featured_product',
                          product: _con.featuredProducts.elementAt(index),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // _con.reviews.isEmpty
                    //     ? SizedBox(height: 5)
                    //     : Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    //   child: ListTile(
                    //     dense: true,
                    //     contentPadding: EdgeInsets.symmetric(vertical: 0),
                    //     leading: Icon(
                    //       Icons.recent_actors_outlined,
                    //       color: Theme.of(context).hintColor,
                    //     ),
                    //     title: Text(
                    //       S.of(context).what_they_say,
                    //       style: Theme.of(context).textTheme.headline4,
                    //     ),
                    //   ),
                    // ),
                    // _con.reviews.isEmpty
                    //     ? SizedBox(height: 5)
                    //     : Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //   child: ReviewsListWidget(reviewsList: _con.reviews),
                    // ),
                  ],
              ),
//                           Stack(
//                     fit: StackFit.expand,
//                     children: <Widget>[
//                       CustomScrollView(
//                         primary: true,
//                         shrinkWrap: false,
//                         slivers: <Widget>[
//                           SliverAppBar(
//                             backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
//                             expandedHeight: 300,
//                             elevation: 0,
// //                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
//                             automaticallyImplyLeading: false,
//                             leading: new IconButton(
//                               icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
//                               onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
//                             ),
//                             flexibleSpace: FlexibleSpaceBar(
//                               collapseMode: CollapseMode.parallax,
//                               background: Hero(
//                                 tag: (widget?.routeArgument?.heroTag ?? '') + _con.market.id,
//                                 child: CachedNetworkImage(
//                                   fit: BoxFit.cover,
//                                   imageUrl: _con.market.image.url,
//                                   placeholder: (context, url) => Image.asset(
//                                     'assets/img/loading.gif',
//                                     fit: BoxFit.cover,
//                                   ),
//                                   errorWidget: (context, url, error) => Icon(Icons.error_outline),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SliverToBoxAdapter(
//                             child: Wrap(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 25),
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text(
//                                           _con.market?.name ?? '',
//                                           overflow: TextOverflow.fade,
//                                           softWrap: false,
//                                           maxLines: 2,
//                                           style: Theme.of(context).textTheme.headline3,
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 32,
//                                         child: Chip(
//                                           padding: EdgeInsets.all(0),
//                                           label: Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: <Widget>[
//                                               Text(_con.market.rate, style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColor))),
//                                               Icon(
//                                                 Icons.star_border,
//                                                 color: Theme.of(context).primaryColor,
//                                                 size: 16,
//                                               ),
//                                             ],
//                                           ),
//                                           backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
//                                           shape: StadiumBorder(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Row(
//                                   children: <Widget>[
//                                     SizedBox(width: 20),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
//                                       decoration: BoxDecoration(color: _con.market.closed ? Colors.grey : Colors.green, borderRadius: BorderRadius.circular(24)),
//                                       child: _con.market.closed
//                                           ? Text(
//                                               S.of(context).closed,
//                                               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
//                                             )
//                                           : Text(
//                                               S.of(context).open,
//                                               style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
//                                             ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(child: SizedBox(height: 0)),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
//                                       decoration: BoxDecoration(color: Helper.canDelivery(_con.market) ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(24)),
//                                       child: Text(
//                                         Helper.getDistance(_con.market.distance, Helper.of(context).trans(setting.value.distanceUnit)),
//                                         style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
//                                       ),
//                                     ),
//                                     SizedBox(width: 20),
//                                   ],
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                   child: Helper.applyHtml(context, _con.market.description),
//                                 ),
//                                 ImageThumbCarouselWidget(galleriesList: _con.galleries),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                                   child: ListTile(
//                                     dense: true,
//                                     contentPadding: EdgeInsets.symmetric(vertical: 0),
//                                     leading: Icon(
//                                       Icons.stars_outlined,
//                                       color: Theme.of(context).hintColor,
//                                     ),
//                                     title: Text(
//                                       S.of(context).information,
//                                       style: Theme.of(context).textTheme.headline4,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                   child: Helper.applyHtml(context, _con.market.information),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                                   margin: const EdgeInsets.symmetric(vertical: 5),
//                                   color: Theme.of(context).primaryColor,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text(
//                                           currentUser.value.apiToken != null ? S.of(context).forMoreDetailsPleaseChatWithOurManagers : S.of(context).signinToChatWithOurManagers,
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 3,
//                                           style: Theme.of(context).textTheme.bodyText1,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       SizedBox(
//                                         width: 42,
//                                         height: 42,
//                                         child: MaterialButton(
//                                           elevation: 0,
//                                           padding: EdgeInsets.all(0),
//                                           disabledColor: Theme.of(context).focusColor.withOpacity(0.5),
//                                           onPressed: currentUser.value.apiToken != null
//                                               ? () {
//                                                   Navigator.of(context).pushNamed('/Chat',
//                                                       arguments: RouteArgument(
//                                                           param: new Conversation(
//                                                               _con.market.users.map((e) {
//                                                                 e.image = _con.market.image;
//                                                                 return e;
//                                                               }).toList(),
//                                                               name: _con.market.name)));
//                                                 }
//                                               : null,
//                                           child: Icon(
//                                             Icons.chat_outlined,
//                                             color: Theme.of(context).primaryColor,
//                                             size: 24,
//                                           ),
//                                           color: Theme.of(context).accentColor.withOpacity(0.9),
//                                           shape: StadiumBorder(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                                   margin: const EdgeInsets.symmetric(vertical: 5),
//                                   color: Theme.of(context).primaryColor,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text(
//                                           _con.market.address ?? '',
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 2,
//                                           style: Theme.of(context).textTheme.bodyText1,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       SizedBox(
//                                         width: 42,
//                                         height: 42,
//                                         child: MaterialButton(
//                                           elevation: 0,
//                                           padding: EdgeInsets.all(0),
//                                           onPressed: () {
//                                             Navigator.of(context).pushNamed('/Pages', arguments: new RouteArgument(id: '1', param: _con.market));
//                                           },
//                                           child: Icon(
//                                             Icons.directions_outlined,
//                                             color: Theme.of(context).primaryColor,
//                                             size: 24,
//                                           ),
//                                           color: Theme.of(context).accentColor.withOpacity(0.9),
//                                           shape: StadiumBorder(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                                   margin: const EdgeInsets.symmetric(vertical: 5),
//                                   color: Theme.of(context).primaryColor,
//                                   child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text(
//                                           '${_con.market.phone} \n${_con.market.mobile}',
//                                           overflow: TextOverflow.ellipsis,
//                                           style: Theme.of(context).textTheme.bodyText1,
//                                         ),
//                                       ),
//                                       SizedBox(width: 10),
//                                       SizedBox(
//                                         width: 42,
//                                         height: 42,
//                                         child: MaterialButton(
//                                           elevation: 0,
//                                           padding: EdgeInsets.all(0),
//                                           onPressed: () {
//                                             launch("tel:${_con.market.mobile}");
//                                           },
//                                           child: Icon(
//                                             Icons.call_outlined,
//                                             color: Theme.of(context).primaryColor,
//                                             size: 24,
//                                           ),
//                                           color: Theme.of(context).accentColor.withOpacity(0.9),
//                                           shape: StadiumBorder(),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 _con.featuredProducts.isEmpty
//                                     ? SizedBox(height: 0)
//                                     : Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                                         child: ListTile(
//                                           dense: true,
//                                           contentPadding: EdgeInsets.symmetric(vertical: 0),
//                                           leading: Icon(
//                                             Icons.shopping_basket_outlined,
//                                             color: Theme.of(context).hintColor,
//                                           ),
//                                           title: Text(
//                                             S.of(context).featured_products,
//                                             style: Theme.of(context).textTheme.headline4,
//                                           ),
//                                         ),
//                                       ),
//                                 _con.featuredProducts.isEmpty
//                                     ? SizedBox(height: 0)
//                                     : ListView.separated(
//                                         padding: EdgeInsets.symmetric(vertical: 10),
//                                         scrollDirection: Axis.vertical,
//                                         shrinkWrap: true,
//                                         primary: false,
//                                         itemCount: _con.featuredProducts.length,
//                                         separatorBuilder: (context, index) {
//                                           return SizedBox(height: 10);
//                                         },
//                                         itemBuilder: (context, index) {
//                                           return ProductItemWidget(
//                                             heroTag: 'details_featured_product',
//                                             product: _con.featuredProducts.elementAt(index),
//                                           );
//                                         },
//                                       ),
//                                 SizedBox(height: 100),
//                                 _con.reviews.isEmpty
//                                     ? SizedBox(height: 5)
//                                     : Padding(
//                                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                         child: ListTile(
//                                           dense: true,
//                                           contentPadding: EdgeInsets.symmetric(vertical: 0),
//                                           leading: Icon(
//                                             Icons.recent_actors_outlined,
//                                             color: Theme.of(context).hintColor,
//                                           ),
//                                           title: Text(
//                                             S.of(context).what_they_say,
//                                             style: Theme.of(context).textTheme.headline4,
//                                           ),
//                                         ),
//                                       ),
//                                 _con.reviews.isEmpty
//                                     ? SizedBox(height: 5)
//                                     : Padding(
//                                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                         child: ReviewsListWidget(reviewsList: _con.reviews),
//                                       ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Positioned(
//                         top: 32,
//                         right: 20,
//                         child: ShoppingCartFloatButtonWidget(
//                             iconColor: Theme.of(context).primaryColor,
//                             labelColor: Theme.of(context).hintColor,
//                             routeArgument: RouteArgument(id: '0', param: _con.market.id, heroTag: 'home_slide')),
//                       ),
//                     ],
//                   ),
            ],
          ),
                ),
              )
        ));
  }
}
