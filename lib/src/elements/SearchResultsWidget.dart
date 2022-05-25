import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/search_controller.dart';
import '../elements/CardWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ProductItemWidget.dart';
import '../models/route_argument.dart';
import 'AllCategoriesItemWidget.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key key, this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends StateMVC<SearchResultWidget> {
  SearchController _con;

  _SearchResultWidgetState() : super(SearchController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                S.of(context).search,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).ordered_by_nearby_first,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                await _con.refreshSearch(text);
                _con.saveSearch(text);
              },
              // onChanged: (value) async {
              //   await _con.refreshSearch(value);
              //   _con.saveSearch(value);
              // },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: "Search for products or markets or categories",
                hintStyle: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 14)),
                prefixIcon: Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          _con.markets.isEmpty && _con.products.isEmpty && _con.categories.isEmpty
          && _con.isProductGet && _con.isMarketGet && _con.isCategoriesGet
              ? CircularLoadingWidget(height: 288) :
          _con.markets.isEmpty && _con.products.isEmpty && _con.categories.isEmpty
              && _con.isProductGet == false && _con.isMarketGet== false && _con.isCategoriesGet== false
          ? Container(
            alignment: AlignmentDirectional.center,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "No results found",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18,),
            ),
          )
              : Expanded(
                  child: ListView(
                    children: <Widget>[
                      Visibility(
                        visible: _con.products.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              S.of(context).products_results,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _con.products.isNotEmpty,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.products.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return ProductItemWidget(
                              heroTag: 'search_list',
                              product: _con.products.elementAt(index),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: _con.categories.isNotEmpty,
                        // visible: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left: 20, right: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              S.of(context).category,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _con.categories.isNotEmpty,
                        // visible:false,
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.categories.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            return AllCategoriesItemWidget(
                              marginLeft: 0,
                              category: _con.categories.elementAt(index),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: _con.markets.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            title: Text(
                              S.of(context).markets_results,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _con.markets.isNotEmpty,
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.markets.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/Details',
                                    arguments: RouteArgument(
                                      id: '0',
                                      param: _con.markets.elementAt(index).id,
                                      heroTag: widget.heroTag,
                                    ));
                              },
                              child: CardWidget(market: _con.markets.elementAt(index), heroTag: widget.heroTag),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
