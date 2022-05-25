import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/category_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ProductListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/route_argument.dart';
import '../helpers/app_config.dart' as config;
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';


class SubCategoryWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  final String name;

  SubCategoryWidget({Key key, this.routeArgument, this.name}) : super(key: key);

  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends StateMVC<SubCategoryWidget> {

  CategoryController _con;

  _SubCategoryWidgetState() : super(CategoryController()) {
    _con = controller;
  }

  bool loading = true;

  SimpleFontelicoProgressDialog dialog;

  @override
  void initState() {

    dialog = SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
    _con.listenForProductsBySubCategory(id: widget.routeArgument.id);
    _con.listenForCategory(id: widget.routeArgument.id);
    _con.listenForCart();

    Timer(Duration(seconds: 5), () {
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
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          // _con.category?.name ?? '',
          widget.routeArgument.param ?? '',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          _con.loadCart
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.5, vertical: 15),
            child: SizedBox(
              width: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
              ),
            ),
          )
              : ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshCategory,
        child: Column(
          children: [

            // loading
            //     ? SizedBox(
            //   height: 3,
            //   child: LinearProgressIndicator(
            //     backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            //   ),
            // )
            //     : SizedBox(),

            Visibility(
              visible:  _con.products.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10, ),
                child: SearchBarWidget(onClickFilter: (filter) {
                  _con.scaffoldKey?.currentState?.openEndDrawer();
                }),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    SizedBox(height: 10),
                    _con.products.isEmpty && _con.isProductGet?
                    Container(
                      height: MediaQuery.of(context).size.height*0.8,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new CircularProgressIndicator(
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Center(child: Text("Loading...", style: Theme.of(context)
                                .textTheme
                                .headline6
                                .merge(TextStyle(letterSpacing: 1.3)),)),
                          ),
                        ],
                      ),
                    ):
                    _con.products.isEmpty && _con.isProductGet == false?
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
                              S.of(context).youDontHaveAnyItemInCategory,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18,),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ):
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _con.products.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return ProductListItemWidget(
                          heroTag: 'favorites_list',
                          product: _con.products.elementAt(index),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
