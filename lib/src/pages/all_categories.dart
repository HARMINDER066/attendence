import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/all_categories_controller.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class AllCategories extends StatefulWidget {

final GlobalKey<ScaffoldState> parentScaffoldKey;
AllCategories({Key key, this.parentScaffoldKey}) : super(key: key);

@override
AllCategoriesState createState() => AllCategoriesState();
}

class AllCategoriesState extends StateMVC<AllCategories> {
AllCategoriesController _con;
String defaultSelection;

AllCategoriesState() : super(AllCategoriesController()) {
  _con = controller;
}


void initState() {
  super.initState();
  print('Load Event ${_con.categories}');
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
            S.of(context).category,
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
      onRefresh: _con.refreshAllCategoriesProduct,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SearchBarWidget(
              onClickFilter: (event) {
                widget.parentScaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: this._con.categories.length,
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                return new Column(
                  children: <Widget>[
                    InkWell(
                      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        setState((){
                          if( defaultSelection == _con.categories[index].id) {
                            defaultSelection = '';
                          }
                          else
                            {
                              defaultSelection = _con.categories[index].id;

                            }
                          // print("bydefaultselectitem id ${defaultSelection}");//if you want to assign the index somewhere to check
                        });
                        // Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id: category.id, param: category.name));
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        alignment: Alignment.center,
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
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Hero(
                                tag: _con.categories[index].id,
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                                  width: 100,
                                  height: 100,
                                  // decoration: BoxDecoration(
                                  //     color: Theme.of(context).primaryColor,
                                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                                  //     border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.3)),
                                  //     boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 7.0)]),
                                  child: _con.categories[index].image.url.toLowerCase().endsWith('.svg')
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: SvgPicture.network(
                                      _con.categories[index].image.url,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  )
                                      : ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: _con.categories[index].image.icon,
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //  "UP to 72% OFF",
                                    //   softWrap: true,
                                    //   textAlign: TextAlign.start,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 14,color: Theme.of(context).highlightColor, fontWeight: FontWeight.w500))
                                    // ),
                                    Text(
                                        _con.categories[index].name,
                                        softWrap: true,
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17,color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        _con.categories[index].description,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 12,color: Theme.of(context).accentColor.withOpacity(0.6), fontWeight: FontWeight.w300)),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          _con.categories[index].id == defaultSelection && _con.categories[index].item.length > 0 ? Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                      child:ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (BuildContext ctx, int) {
                                return InkWell(
                                    splashColor: Theme.of(context).accentColor.withOpacity(0.08),
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState((){
                                        // _id = index; //if you want to assign the index somewhere to check
                                      });
                                      Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id: _con.categories[index].id, param: _con.categories[index].name));
                                    },
                                    child:Container(
                                      width: 100,
                                      height: 50,
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
                                      alignment: Alignment.center,
                                      child: Text("All",
                                          style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17,color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))),
                                    )
                                );
                              }
                          ),):Container(),
                          _con.categories[index].id == defaultSelection ? Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                            child:  _con.categories[index].item.length > 0 ? ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: _con.categories[index].item.length,
                                itemBuilder: (BuildContext ctx, int) {
                                  return Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                   child:InkWell(
                                    onTap: () {
                                      setState((){
                                        // _id = index; //if you want to assign the index somewhere to check
                                      });
                                      Navigator.of(context).pushNamed('/Subcategory', arguments: RouteArgument(id: _con.categories[index].item[int].id, param: _con.categories[index].item[int].name));
                                    },
                                      child:Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                        width: 100,
                                    height: 50,
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
                                    alignment: Alignment.center,
                                    child: Text(_con.categories[index].item[int].name,
                                        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17,color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))),
                                  ),
                                  ),
                                  );


                                }
                                ):
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (BuildContext ctx, int) {
                          return InkWell(
                          splashColor: Theme.of(context).accentColor.withOpacity(0.08),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState((){
                              // _id = index; //if you want to assign the index somewhere to check
                            });
                             Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id: _con.categories[index].id, param: _con.categories[index].name));
                          },
                          child:Container(
                            width: 100,
                            height: 50,
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
                        alignment: Alignment.center,
                        child: Text("All",
                            style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17,color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))),
                            )
                            );
                            }
                           ),
                          ):Container(),
                        ],
                      ),
                    ) ,
                  ],
                );
              },
            ),
          )
        ],
      ),
    ),
  );
}
}
