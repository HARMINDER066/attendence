import 'package:flutter/material.dart';
import '../elements/AllTrendingProductsItemWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/market_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductsCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/market.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MenuWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  MarketController _con;
  List<String> selectedCategories;

  _MenuWidgetState() : super(MarketController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.market = widget.routeArgument.param as Market;
    _con.listenForTrendingProducts(_con.market.id);
    _con.listenForCategories(_con.market.id);
    selectedCategories = ['0'];
    _con.listenForProducts(_con.market.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: new Image.asset('assets/img/icon_sort.png', color: Theme.of(context).hintColor, width: 18, height: 16,),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        title: Text(
          _con.market?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15,),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                horizontalTitleGap: 2,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                leading: Icon(
                  Icons.bookmark_outline,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  S.of(context).featured_products,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            ProductsCarouselWidget(heroTag: 'menu_trending_product', productsList: _con.trendingProducts),

            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 15, left: 15),
              child: Text(
                S.of(context).product_categories,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),

            // ListTile(
            //   dense: true,
            //   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   leading: Icon(
            //     Icons.subject,
            //     color: Theme.of(context).hintColor,
            //   ),
            //   title: Text(
            //     S.of(context).products,
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle: Text(
            //     S.of(context).clickOnTheProductToGetMoreDetailsAboutIt,
            //     maxLines: 2,
            //     style: Theme.of(context).textTheme.caption,
            //   ),
            // ),
            _con.categories.isEmpty
                ? SizedBox(height: 90)
                : Container(
                    height: 90,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_con.categories.length, (index) {
                        var _category = _con.categories.elementAt(index);
                        var _selected = this.selectedCategories.contains(_category.id);
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 8),
                          child: RawChip(
                            elevation: 1,
                            label: Text(_category.name),
                            labelStyle: _selected
                                ? Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor))
                                : Theme.of(context).textTheme.bodyText2,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            backgroundColor: Theme.of(context).primaryColor,
                            selectedColor: Theme.of(context).buttonColor,
                            selected: _selected,
                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                            showCheckmark: false,
                            // avatar: (_category.id == '0')
                            //     ? null
                            //     : (_category.image.url.toLowerCase().endsWith('.svg')
                            //         ? SvgPicture.network(
                            //             _category.image.url,
                            //             color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                            //           )
                            //         : CachedNetworkImage(
                            //             fit: BoxFit.cover,
                            //             imageUrl: _category.image.icon,
                            //             placeholder: (context, url) => Image.asset(
                            //               'assets/img/loading.gif',
                            //               fit: BoxFit.cover,
                            //             ),
                            //             errorWidget: (context, url, error) => Icon(Icons.error_outline),
                            //           )),
                            onSelected: (bool value) {
                              setState(() {
                                if (_category.id == '0') {
                                  this.selectedCategories = ['0'];
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == '0');
                                }
                                if (value) {
                                  this.selectedCategories.add(_category.id);
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == _category.id);
                                }
                                _con.selectCategory(this.selectedCategories);
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
            _con.products.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.products.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return AllTrendingProductsItemWidget(
                        heroTag: 'menu_list',
                        marginLeft: 0,
                        product: _con.products.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
