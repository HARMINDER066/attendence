import 'package:flutter/material.dart';

import '../elements/DrawerWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../pages/home.dart';
import '../pages/map.dart';
import '../pages/notifications.dart';
import '../pages/orders.dart';
import 'all_categories.dart';

class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 2;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = MapWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: widget.routeArgument);
          break;
        case 1:
          widget.currentPage = AllCategories(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage = NotificationsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          items: [
            BottomNavigationBarItem(
              icon: widget.currentTab == 0 ?  Image.asset('assets/img/icon_bottom_location_select.png', width: 22, height: 22,color: Theme.of(context).buttonColor) : Image.asset('assets/img/icon_bottom_location_unselect.png', width: 20, height: 20,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: widget.currentTab == 1 ?  Image.asset('assets/img/icon_bottom_category_selected.png', width: 22, height: 22, color: Theme.of(context).buttonColor,) : Image.asset('assets/img/icon_bottom_category_unselected.png', width: 20, height: 20,),
              label: '',
            ),
            BottomNavigationBarItem(
                label: '',
                icon: Container(
                  width: 45,
                  height: 45,
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: Theme.of(context).buttonColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: widget.currentTab == 2 ?  Image.asset('assets/img/icon_bottom_home_selected.png', width: 22, height: 22,)  : Image.asset('assets/img/icon_bottom_home_unselect.png', width: 20, height: 20,),
                )
              ),
            BottomNavigationBarItem(
              icon: widget.currentTab == 3 ?  Image.asset('assets/img/icon_myorder_selected.png', width: 22, height: 22,color: Theme.of(context).buttonColor) : Image.asset('assets/img/icon_myorder_unselect.png', width: 20, height: 20,),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: widget.currentTab == 4 ?  Image.asset('assets/img/icon_bottom_notification_selected.png', width: 22, height: 22,color: Theme.of(context).buttonColor) : Image.asset('assets/img/icon_bottom_notifications_unselected.png', width: 20, height: 20,),
              label: '',
            ),
          ],
        ),

        floatingActionButton: Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: FloatingActionButton(
              child: widget.currentTab == 2 ?  Image.asset('assets/img/icon_bottom_home_selected.png', width: 22, height: 22,) : Image.asset('assets/img/icon_bottom_home_unselect.png', width: 20, height: 20,),
              backgroundColor: Theme.of(context).accentColor,
              onPressed: () {
               setState(() {
                 this._selectTab(2);
               });
              },
            ),
          ),
        ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      ),
    );
  }
}
