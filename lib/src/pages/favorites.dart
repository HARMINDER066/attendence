import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/favorite_controller.dart';
import '../helpers/app_config.dart' as config;
import '../elements/FavoriteListItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../repository/user_repository.dart';

class FavoritesWidget extends StatefulWidget {
  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends StateMVC<FavoritesWidget> {

  FavoriteController _con;

  _FavoritesWidgetState() : super(FavoriteController()) {
    _con = controller;
  }

  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });

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
            icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => {
              Navigator.of(context).pop(),
            },
          ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).favorites_products,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor:Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
              onRefresh: _con.refreshFavorites,
              child: SingleChildScrollView(
                // padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: SearchBarWidget(onClickFilter: (e) {
                    //     Scaffold.of(context).openEndDrawer();
                    //   }),
                    // ),
                    // SizedBox(height: 10),
                    _con.favorites.isEmpty
                        ? Column(
                          children: [
                            loading
                                ? SizedBox(
                              height: 3,
                              child: LinearProgressIndicator(
                                backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                              ),
                            )
                                : SizedBox(),
                            Container(
                      alignment: AlignmentDirectional.center,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      height: config.App(context).appHeight(70),
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: 150,
                                height: 150,
                                padding: EdgeInsets.all(35),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor
                                ),
                                child: Image.asset('assets/img/icon_empty_order.png'),
                              ),
                              SizedBox(height: 30),
                              Opacity(
                                opacity: 0.5,
                                child: Text(
                                  S.of(context).youDontHaveAnyFavProd,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,),
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                      ),
                    ),
                          ],
                        )
                        : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _con.favorites.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return FavoriteListItemWidget(
                              heroTag: 'favorites_list_',
                              favorite: _con.favorites.elementAt(index), onDelete: () => removeItem(index),
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
    );
  }

  void removeItem(int index) {
    setState(() {
      _con.favorites = List.from(_con.favorites)
        ..removeAt(index);
      // ScaffoldMessenger.of(_con.scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(_con.state.context).thisProductWasRemovedFromFavorites),
      //   behavior: SnackBarBehavior.floating,
      // ));
    });
  }
}
