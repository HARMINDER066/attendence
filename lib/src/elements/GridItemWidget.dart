import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/product_controller.dart';
import '../helpers/helper.dart';
import '../models/product.dart';
import '../models/route_argument.dart';
import '../pages/dropdown_dialog_screen.dart';
import '../repository/user_repository.dart';

class GridItemWidget extends StatefulWidget {
  final Product product;
  final String heroTag;

  GridItemWidget({Key key, this.product, this.heroTag}) : super(key: key);

  @override
  GridItemWidgetState createState() => GridItemWidgetState();
}

class GridItemWidgetState extends StateMVC<GridItemWidget> {
  String quantity = "Select";
  bool isAddToCart = false;

  ProductController _con;

  GridItemWidgetState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    // _con.listenForFavorite(productId: widget.product.id);
    favouriteProduct.value = widget.product?.favorite_flag;
    if(widget.product.total_quantity>0.0){
      _con.quantity = widget.product.total_quantity;
      _con.calculateTotal(widget.product);
      setState(() { });
    }

      if (widget.product.optionGroups.isNotEmpty) {
        var optionGroup = widget.product.optionGroups.elementAt(0);
        quantity = widget.product.options.where((option) => option.optionGroupId == optionGroup.id).elementAt(0).name;
        widget.product.options.where((option) => option.optionGroupId == optionGroup.id).elementAt(0).checked = true;
        _con.calculateTotal(widget.product);
        setState(() { });
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        // Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: widget.product.id, heroTag: widget.heroTag));
        Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: widget.product.id, heroTag: widget.heroTag));
      },
      child: Container(
        key: _con.scaffoldKey,
        margin: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.market.name,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          this.widget.product.name,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),

                // ValueListenableBuilder<int>(
                //   valueListenable: favouriteProduct,
                //   builder: (context, value, child) {
                //     return value == 1  ? IconButton(
                //       splashColor: Colors.transparent,
                //       highlightColor: Colors.transparent,
                //       onPressed: () {
                //         // _con.removeFromFavorite(_con.favorite);
                //         _con.removeFromFavorite(widget.product.favourite.first);
                //         // ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                //         //   content: Text(S.of(_con.state.context).thisProductWasRemovedFromFavorites),
                //         //   behavior: SnackBarBehavior.floating,
                //         // ));
                //         setState(() {
                //           widget.product?.favorite_flag =0;
                //         });
                //         favouriteProduct.value = 0;
                //       },
                //       iconSize: 24,
                //       icon: Icon(Icons.favorite),
                //       color: const Color(0xFFFF9900),
                //     )
                //         : IconButton(
                //       splashColor: Colors.transparent,
                //       highlightColor: Colors.transparent,
                //       onPressed: () {
                //         setState(() {
                //           widget.product?.favorite_flag =1;
                //         });
                //         favouriteProduct.value = 1;
                //         _con.addToFavorite(widget.product);
                //       },
                //       iconSize: 24,
                //       icon: Icon(Icons.favorite_border_rounded),
                //       color: Theme.of(context).hintColor.withOpacity(0.2),
                //     );
                //   },
                // ),

                // _con.favorite?.id != null

                widget.product?.favorite_flag == 1
                    ? IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                        onPressed: () {
                          // _con.removeFromFavorite(_con.favorite);
                          _con.removeFromFavorite(widget.product.favourite.first);
                          // ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
                          //   content: Text(S.of(_con.state.context).thisProductWasRemovedFromFavorites),
                          //   behavior: SnackBarBehavior.floating,
                          // ));
                          setState(() { widget.product?.favorite_flag =0;});
                        },
                        iconSize: 24,
                        icon: Icon(Icons.favorite),
                        color: const Color(0xFFFF9900),
                      )
                    : IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() { widget.product?.favorite_flag =1;});
                          _con.addToFavorite(widget.product);
                        },
                        iconSize: 24,
                        icon: Icon(Icons.favorite_border_rounded),
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Hero(
                tag: widget.heroTag + widget.product.id,
                child: Container(
                  width: 100,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.product.image.thumb,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: quantity != "Select",
              child: GestureDetector(
                onTap: () async {
                  var data = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: DropdownDialogScreen(
                            product: widget.product,
                            onChanged_: (){
                              _con.calculateTotal(widget.product);
                            },
                          ),
                        );
                      });

                  if(data !=null && data !=""){
                    _con.quantity = 0.0;
                    _con.calculateTotal(widget.product);
                    quantity = data.toString().split("-").first;
                    setState(() { });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xFFC9C6C6).withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Helper.getPrice(
                  _con.total==0.0?widget.product.price: _con.total,
                  context,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Theme.of(context).accentColor),
                ),
                widget.product.discountPrice > 0
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Helper.getPrice(widget.product.discountPrice, context,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).hintColor,
                                decoration: TextDecoration.lineThrough)),
                      )
                    : SizedBox(height: 0),
              ],
            ),

            Visibility(
              visible:  _con.quantity>0.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _con.decrementQuantity(widget.product);
                    },
                    iconSize: 30,
                    icon: Icon(Icons.remove_circle_outline),
                    color: Theme.of(context).buttonColor.withOpacity(0.5),
                  ),
                  Text(_con.quantity.toString(), style: Theme.of(context).textTheme.subtitle2),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _con.incrementQuantity(widget.product);
                    },
                    iconSize: 30,
                    icon: Icon(Icons.add_circle_rounded),
                    color: Theme.of(context).buttonColor,
                  )
                ],
              ),
            ),

            //add to cart
            Visibility(
              visible: _con.quantity==0.0,
              child: MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  setState(() {
                    isAddToCart = true;
                    if (currentUser.value.apiToken == null) {
                      Navigator.of(context).pushNamed("/Login");
                    } else {
                      if (_con.isSameMarkets(widget.product)) {
                        _con.addToCart(widget.product);
                      } else {
                        _con.addToCart(widget.product, reset: false);
                      }
                    }
                  });
                },
                color: Theme.of(context).buttonColor,
                shape: StadiumBorder(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "ADD",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
