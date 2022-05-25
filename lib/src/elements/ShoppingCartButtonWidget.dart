import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _ShoppingCartButtonWidgetState createState() => _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState extends StateMVC<ShoppingCartButtonWidget> {
  CartController _con;

  _ShoppingCartButtonWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForCartsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: cartCount,
        builder: (context, value, child) {
          return MaterialButton(
            key: _con.scaffoldKey,
            elevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              if (currentUser.value.apiToken != null) {
                Navigator.of(context).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                Icon(
                  Icons.shopping_cart_outlined,
                  color: this.widget.iconColor,
                  size: 28,
                ),
                Container(
                  child: Text(
                    cartCount.value.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(color: Theme.of(context).primaryColor, fontSize: 10),
                    ),
                  ),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                  constraints: BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
                ),
              ],
            ),
            color: Colors.transparent,
          );
        }
    );
  }
}
