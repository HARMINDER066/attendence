import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/AllPopularProductController.dart';
import '../elements/AllTrendingProductsItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart' as settingsRepo;

class ViewAllPopularProductScreen extends StatefulWidget{
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ViewAllPopularProductScreen({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  ViewAllPopularProductScreenState createState() => ViewAllPopularProductScreenState();

}
class ViewAllPopularProductScreenState extends StateMVC<ViewAllPopularProductScreen>{

  AllPopularProductController _con;

  ViewAllPopularProductScreenState() : super(AllPopularProductController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              S.of(context).most_popular,
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
        onRefresh: _con.refreshAllTrendingProduct,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SearchBarWidget(
              onClickFilter: (event) {
                widget.parentScaffoldKey.currentState.openEndDrawer();
              },
            ),
          ),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _con.popularProducts.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  double _marginLeft = 0;
                  return AllTrendingProductsItemWidget(
                    heroTag: "home_product_carousel",
                    marginLeft: _marginLeft,
                    product: _con.popularProducts.elementAt(index),
                  );
                },
                scrollDirection: Axis.vertical,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}