import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/tracking_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/ProductOrderItemWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../helpers/helper.dart';
import '../models/route_argument.dart';

class TrackingWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  TrackingWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends StateMVC<TrackingWidget> with SingleTickerProviderStateMixin {
  TrackingController _con;
  TabController _tabController;
  int _tabIndex = 0;

  _TrackingWidgetState() : super(TrackingController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForOrder(orderId: widget.routeArgument.id);
    _tabController = TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Theme.of(context).accentColor);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
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
          bottom: PreferredSize(
              child: Container(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                height: 0.5,
              ),
              preferredSize: Size.fromHeight(4.0)),
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).orderDetails,
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).highlightColor),
          ],
        ),
        body: _con.order == null || _con.orderStatus.isEmpty
            ? CircularLoadingWidget(height: 400) :
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: SingleChildScrollView(
                 physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        unselectedLabelColor: Theme.of(context).accentColor,
                        labelColor: Theme.of(context).primaryColor,
                        indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Theme.of(context).accentColor),
                        tabs: [
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Theme.of(context).accentColor.withOpacity(0.2), width: 1)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(S.of(context).details),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Theme.of(context).accentColor.withOpacity(0.2), width: 1)),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(S.of(context).tracking_order),
                              ),
                            ),
                          ),
                        ]),
                    Offstage(
                      offstage: 0 != _tabIndex,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${S.of(context).order_id}: #${_con.order.id}',
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy | hh:mm a').format(_con.order.dateTime),
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4,top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      _con.order.active ? '${_con.order.orderStatus.status}' : S.of(context).canceled,
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      style: Theme.of(context).textTheme.caption.merge(TextStyle(height: 1, color:  _con.order.active? Theme.of(context).highlightColor:Colors.redAccent , fontWeight: FontWeight.w600)),
                                    ),
                                    Text(
                                      '${_con.order.payment.method}',
                                      style: Theme.of(context).textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Column(
                                    children: List.generate(
                                      _con.order.productOrders.length,
                                          (indexProduct) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric( vertical: 8),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed('/Product', arguments: RouteArgument(id: _con.order.productOrders.elementAt(indexProduct).product.id));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Hero(
                                                  tag: "my_order" +  _con.order.productOrders.elementAt(indexProduct)?.id,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                    child: CachedNetworkImage(
                                                      height: 60,
                                                      width: 60,
                                                      fit: BoxFit.cover,
                                                      imageUrl:  _con.order.productOrders.elementAt(indexProduct).product.image.thumb,
                                                      placeholder: (context, url) => Image.asset(
                                                        'assets/img/loading.gif',
                                                        fit: BoxFit.cover,
                                                        height: 60,
                                                        width: 60,
                                                      ),
                                                      errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 15),
                                                Flexible(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                              _con.order.productOrders.elementAt(indexProduct).product.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: Theme.of(context).textTheme.subtitle1,
                                                            ),
                                                            Wrap(
                                                              children: List.generate( _con.order.productOrders.elementAt(indexProduct).options.length, (index) {
                                                                return Text(
                                                                  _con.order.productOrders.elementAt(indexProduct).options.elementAt(index).name + ', ',
                                                                  style: Theme.of(context).textTheme.caption,
                                                                );
                                                              }),
                                                            ),
                                                            Text(
                                                              _con.order.productOrders.elementAt(indexProduct).product.market.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: Theme.of(context).textTheme.caption,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          Helper.getPrice(Helper.getOrderPrice( _con.order.productOrders.elementAt(indexProduct)), context, style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 14))),
                                                          Text(
                                                            " x " +  _con.order.productOrders.elementAt(indexProduct).quantity.toString(),
                                                            style: Theme.of(context).textTheme.subtitle2,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Text(
                                  '${S.of(context).price_details}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).delivery_fee,
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        if(_con.order.deliveryFee != 0.0)
                                          Helper.getPrice(_con.order.deliveryFee, context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: S.of(context).free)
                                        else
                                          Text("Free", style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).highlightColor)),)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            '${S.of(context).tax} (${_con.order.tax}%)',
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        Helper.getPrice(Helper.getTaxOrder(_con.order), context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: S.of(context).free)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            S.of(context).total,
                                            style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)),
                                          ),
                                        ),
                                        Helper.getPrice(Helper.getTotalOrdersPrice(_con.order), context, style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w400, color: Theme.of(context).accentColor)), zeroPlaceholder: S.of(context).free)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4,top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (_con.order.canCancelOrder())
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: GestureDetector(
                                          onTap: (){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: Wrap(
                                                    spacing: 10,
                                                    children: <Widget>[
                                                      Icon(Icons.report_outlined, color: Colors.orange),
                                                      Text(
                                                        S.of(context).confirmation,
                                                        style: TextStyle(color: Colors.orange),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Text(S.of(context).areYouSureYouWantToCancelThisOrder),
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      elevation: 0,
                                                      child: new Text(
                                                        S.of(context).yes,
                                                        style: TextStyle(color: Theme.of(context).hintColor),
                                                      ),
                                                      onPressed: () {
                                                        _con.doCancelOrder();
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      elevation: 0,
                                                      child: new Text(
                                                        S.of(context).close,
                                                        style: TextStyle(color: Colors.orange),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                                border: Border.all(color: Theme.of(context).accentColor)
                                            ),
                                            child: Text(S.of(context).cancelOrder),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: 1 != _tabIndex,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Theme(
                              data: ThemeData(
                                  colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).accentColor,
                                  )
                              ),
                              child: Stepper(
                                physics: ClampingScrollPhysics(),
                                  controlsBuilder : (context, details) {
                                    return SizedBox(height: 0);
                                  },
                                 // controlsBuilder: (context, {onStepCancel, onStepContinue}) {
                                 //   return SizedBox(height: 0);
                                 // },
                                steps: _con.getTrackingSteps(context),
                                currentStep: int.tryParse(this._con.order.orderStatus.id) - 1,
                              ),
                            ),
                          ),
                          _con.order.deliveryAddress?.address != null
                              ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.9),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Theme.of(context).brightness == Brightness.light ? Colors.black38 : Theme.of(context).backgroundColor),
                                  child: Icon(
                                    Icons.place_outlined,
                                    color: Theme.of(context).primaryColor,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _con.order.deliveryAddress?.description ?? "My Address",
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      Text(
                                        _con.order.deliveryAddress?.address ?? S.of(context).unknown,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                              : SizedBox(height: 0),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
    );
  }
}
