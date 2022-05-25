import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/route_argument.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  Cart cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget({Key key, this.cart, this.heroTag, this.increment, this.decrement, this.onDismissed}) : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends StateMVC<CartItemWidget> {

  CartController _con;

  _CartItemWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.cart.id),
      onDismissed: (direction) {
        setState(() {
          widget.onDismissed();
        });
      },
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: widget.cart.product.id, heroTag: widget.heroTag));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageUrl: widget.cart.product.image.thumb,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      height: 90,
                      width: 90,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error_outline),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.cart.product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          Wrap(
                            children: List.generate(widget.cart.options.length, (index) {
                              return Text(
                                widget.cart.options.elementAt(index).name + ', ',
                                style: Theme.of(context).textTheme.subtitle2,
                              );
                            }),
                          ),
                          // Text(
                          //   widget.cart.options.elementAt(index).name,
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 2,
                          //   style: Theme.of(context).textTheme.subtitle2,
                          // ),
                        ],
                      ),
                    ),
                    // Wrap(
                    //   children: List.generate(widget.cart.options.length, (index) {
                    //     return Text(
                    //       widget.cart.options.elementAt(index).name + ', ',
                    //       style: Theme.of(context).textTheme.bodyText2,
                    //     );
                    //   }),
                    // ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: <Widget>[
                        Helper.getPrice(widget.cart.getProductPrice(), context, style: Theme.of(context).textTheme.headline4.merge(TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color:  Theme.of(context).accentColor),), zeroPlaceholder: '-'),
                        widget.cart.product.discountPrice > 0
                            ? Helper.getPrice(widget.cart.product.discountPrice, context,
                                style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300, color:  Theme.of(context).hintColor, decoration: TextDecoration.lineThrough))
                            : SizedBox(height: 0),
                      ],
                    ),
                    //Helper.getPrice(widget.cart.getProductPrice(), context, style: Theme.of(context).textTheme.headline4)

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              if(widget.cart.quantity == 1){
                                widget.onDismissed();
                              }else{
                                widget.decrement();
                              }
                            });
                          },
                          iconSize: 25,
                          icon: Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor.withOpacity(0.3),
                        ),
                        Text(widget.cart.quantity.toString(),  style: Theme.of(context).textTheme.subtitle2),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 25,
                          icon: Icon(Icons.add_circle_rounded),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
