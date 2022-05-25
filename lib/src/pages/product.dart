import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../models/media.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart' as settingsRepo;
import '../repository/user_repository.dart';
import 'dropdown_dialog_screen.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  RouteArgument routeArgument;

  ProductWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _ProductWidgetState createState() {
    return _ProductWidgetState();
  }
}

class _ProductWidgetState extends StateMVC<ProductWidget> {
  ProductController _con;

  _ProductWidgetState() : super(ProductController()) {
    _con = controller;
  }

  String quantity = "Select";
  bool isAddToCart = false;
  bool quantityVisible = false;
  bool load= true;

  @override
  void initState() {
    loadData().then((_) {
      if (mounted) {
        setState(() {

          if(_con.product !=null){
            if(_con.product.total_quantity>0.0){
              _con.quantity = _con.product.total_quantity;
              _con.calculateTotal(_con.product);
              setState(() { });
            }
          }

          if(_con.product !=null){
            quantityVisible = _con.product.optionGroups.isNotEmpty;
          }

          if (_con.product.optionGroups.isNotEmpty) {
            var optionGroup = _con.product.optionGroups.elementAt(0);
            quantity = _con.product.options
                .where((option) => option.optionGroupId == optionGroup.id)
                .elementAt(0)
                .name;
            _con.product.options
                .where((option) => option.optionGroupId == optionGroup.id)
                .elementAt(0)
                .checked = true;
            _con.calculateTotal(_con.product);
            load = false;
            setState(() { });
          }else{
            load = false;
            setState(() { });
          }
        });
      }
    });


    super.initState();
  }

  Future loadData() async {
    await _con.listenForProduct(productId: widget.routeArgument.id);
    await _con.listenForCart();
    await _con.listenForFavorite(productId: widget.routeArgument.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: settingsRepo.setting,
          builder: (context, value, child) {
            return Text(
              S.of(context).products_details,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            );
          },
        ),
        actions: <Widget>[
          // _con.loadCart
          //     ? Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 15),
          //         child: SizedBox(
          //           width: 26,
          //           child: CircularProgressIndicator(
          //             strokeWidth: 2.5,
          //           ),
          //         ),
          //       )
          //     :
          ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: load
      // _con.product == null || _con.product?.image == null || _con.product?.images == null
          ? CircularLoadingWidget(height: 500)
          : RefreshIndicator(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: _con.refreshProduct,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0.1,
                              blurRadius: 1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 7),
                                height: 220,
                                viewportFraction: 1.0,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _con.current = index;
                                  });
                                },
                              ),
                              items: _con.product.images.map((Media image) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                        child: CachedNetworkImage(
                                          height: 220,
                                          width: double.infinity,
                                          fit: BoxFit.fitHeight,
                                          imageUrl: _con.product.images.elementAt(_con.current).url,
                                          placeholder: (context, url) => Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 220,
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Container(
                              //margin: EdgeInsets.symmetric(vertical: 22, horizontal: 42),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: _con.product.images.map((Media image) {
                                  return Container(
                                    width: _con.current == _con.product.images.indexOf(image)? 20.0 : 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        color: _con.current == _con.product.images.indexOf(image)
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).accentColor.withOpacity(0.4)),
                                  );
                                }).toList(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: _con.favorite?.id != null
                                  ? IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                      onPressed: () {
                                        setState(() {
                                          _con.removeFromFavorite(_con.favorite);
                                          // ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                                          //   content: Text(S.of(_con.state.context).thisProductWasRemovedFromFavorites),
                                          //   behavior: SnackBarBehavior.floating,
                                          // ));
                                        });
                                      },
                                      iconSize: 24,
                                      icon: Icon(Icons.favorite),
                                      color: const Color(0xFFFF9900),
                                    )
                                  : IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                      onPressed: () {
                                        _con.addToFavorite(_con.product);
                                      },
                                      iconSize: 24,
                                      icon: Icon(Icons.favorite_border_rounded),
                                      color: Theme.of(context).hintColor.withOpacity(0.2),
                                    ),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Visibility(
                          visible: _con.product.images.length == 0 ? false : true,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _con.product.images.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _con.current = index;
                                    });
                                  },
                                  child: Container(
                                      width: 70,
                                      height: 70,
                                      margin: EdgeInsetsDirectional.only(start: 5, end: 5),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color:_con.current == index? Theme.of(context).buttonColor:Theme.of(context).focusColor.withOpacity(0.3)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context).focusColor.withOpacity(0.2),
                                                offset: Offset(0, 2),
                                                blurRadius: 7.0)
                                          ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          height: 70,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: _con.product.images[index].url,
                                          placeholder: (context, url) => Image.asset(
                                            'assets/img/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 70,
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                        ),

                                        // Image.network(
                                        //   _con.product.images[index].url,
                                        //   fit: BoxFit.fill,
                                        // ),
                                      )),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _con.product?.market?.name ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                _con.product?.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .merge(TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: quantityVisible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        var data = await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return WillPopScope(
                                                onWillPop: () async => false,
                                                child: DropdownDialogScreen(
                                                  product: _con.product,
                                                  onChanged_: () {
                                                    _con.calculateTotal(_con.product);
                                                  },
                                                ),
                                              );
                                            });

                                        if(data !=null && data !=""){
                                          if(_con.product != null){
                                            _con.quantity = 0.0;
                                            _con.calculateTotal(_con.product);
                                          }
                                          quantity = data.toString().split("-").first;
                                          setState(() { });
                                        }

                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width * 0.30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          color: const Color(0xFFC9C6C6).withOpacity(0.3),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                quantity,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context).textTheme.subtitle2,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Theme.of(context).accentColor.withOpacity(0.2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _con.quantity>0.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          _con.decrementQuantity(_con.product);
                                          setState(() { });
                                        },
                                        iconSize: 30,
                                        icon: Icon(Icons.remove_circle_outline),
                                        color: Theme.of(context).buttonColor,
                                      ),
                                      Text(_con.quantity.toString(), style: Theme.of(context).textTheme.subtitle2),
                                      IconButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          _con.incrementQuantity(_con.product);
                                        },
                                        iconSize: 30,
                                        icon: Icon(Icons.add_circle_rounded),
                                        color: Theme.of(context).buttonColor,
                                      )
                                    ],
                                  ),
                                ),
                                _con.product.manage_quantity == 1.0 && _con.product.input_quantity == 0.0  ? MaterialButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {

                                  },
                                  color: Theme.of(context).buttonColor,
                                  shape: StadiumBorder(),
                                  child: Container(
                                    child: Text(
                                      'Out of Stock',

                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12.0,color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ) :Visibility(
                                  visible: _con.quantity==0.0,
                                  child: MaterialButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    elevation: 0,
                                    onPressed: () {
                                      // setState(() {
                                      if (currentUser.value.apiToken == null) {
                                        Navigator.of(context).pushNamed("/Login");
                                      } else {
                                        if (_con.isSameMarkets(_con.product)) {
                                          _con.addToCart(_con.product);
                                        } else {
                                          _con.addToCart(_con.product, reset: false);
                                        }
                                      }
                                      // });
                                      setState(() {
                                        _con.listenForProduct(productId: widget.routeArgument.id);
                                        isAddToCart = true;
                                      });
                                    },
                                    color: Theme.of(context).buttonColor,
                                    shape: StadiumBorder(),
                                    child: Container(
                                      child: Text(
                                        "Add",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Helper.getPrice(
                                    _con.total,
                                    context,
                                    style: TextStyle(
                                        fontSize: 18.0, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
                                  ),
                                  _con.product.discountPrice > 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Helper.getPrice(_con.product.discountPrice, context,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w300,
                                                  color: Theme.of(context).hintColor,
                                                  decoration: TextDecoration.lineThrough)),
                                        )
                                      : SizedBox(height: 0),
                                  SizedBox(width: 10),
                                  _con.product.manage_quantity == 1.0 ? Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                      decoration:
                                      BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(24)),
                                      child: Text(
                                        _con.product.input_quantity.toInt().toString() + " " + _con.product.unit + " Left",
                                        style:
                                        Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                      )):SizedBox(width: 10),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Helper.canDelivery(_con.product.market) && _con.product.deliverable
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context).buttonColor,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Helper.canDelivery(_con.product.market) && _con.product.deliverable
                                  ? Text(
                                      S.of(context).deliverable,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    )
                                  : Text(
                                      S.of(context).not_deliverable,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .merge(TextStyle(color: Theme.of(context).primaryColor)),
                                    ),
                            ),
                            Expanded(child: SizedBox(height: 0)),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                decoration:
                                    BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  _con.product.capacity + " " + _con.product.unit,
                                  style:
                                      Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                )),

                            SizedBox(width: 5),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                                decoration:
                                    BoxDecoration(color: Theme.of(context).accentColor, borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  _con.product.packageItemsCount + " " + S.of(context).items,
                                  style:
                                      Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).primaryColor)),
                                )),
                          ],
                        ),
                      ),

                      // Divider(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Html(
                          data: _con.product.description,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
