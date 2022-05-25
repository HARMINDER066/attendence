import 'package:eighttoeightneeds/src/elements/FaqItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/faq_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends StateMVC<HelpWidget> {

  FaqController _con;

  _HelpWidgetState() : super(FaqController()) {
    _con = controller;
  }


  @override
  Widget build(BuildContext context) {
    return
      // _con.faqs.isEmpty
      //   ? CircularLoadingWidget(height: 500,):
    Scaffold(
      body: _con.faqs.isEmpty
        ? Center(child: CircularProgressIndicator(color: Colors.blue,)):
        DefaultTabController(
        length: _con.faqs.length,
        child: Scaffold(
          key: _con.scaffoldKey,
          drawer: DrawerWidget(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            leading: new IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: new Image.asset(
                'assets/img/icon_sort.png',
                color: Theme.of(context).hintColor,
                width: 18,
                height: 16,
              ),
              onPressed: () => _con.scaffoldKey.currentState.openDrawer(),
            ),
            bottom: TabBar(
              tabs: List.generate(_con.faqs.length, (index) {
                return Tab(text: _con.faqs.elementAt(index).name ?? '');
              }),
              labelColor: Theme.of(context).accentColor,
            ),
            title: Text(
              S.of(context).help_supports,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
            ),
            actions: <Widget>[
              new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: RefreshIndicator(
            onRefresh: _con.refreshFaqs,
            child:
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            //   child: SingleChildScrollView(
            //     physics: AlwaysScrollableScrollPhysics(),
            //     child: Text (
            //       "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. \n\nThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. \n\nThere are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.",
            //           // style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300, color: config.Colors().mainColor(1), height: 1.4),
            //           style: Theme.of(context).textTheme.headline2.merge(TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300,color:config.Colors().secondColor(1))),
            //     ),
            //   ),
            // ),
            TabBarView(
              children: List.generate(_con.faqs.length, (index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // ListTile(
                      //   contentPadding: EdgeInsets.symmetric(vertical: 0),
                      //   leading: Icon(
                      //     Icons.help_outline,
                      //     color: Theme.of(context).hintColor,
                      //   ),
                      //   title: Text(
                      //     S.of(context).help_supports,
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: Theme.of(context).textTheme.headline4,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.faqs.elementAt(index).faqs.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, indexFaq) {
                            return FaqItemWidget(faq: _con.faqs.elementAt(index).faqs.elementAt(indexFaq));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
