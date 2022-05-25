import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/my_membership_controller.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AllMembershipPlanWidget extends StatefulWidget{

  @override
  AllMembershipPlanWidgetState createState() => AllMembershipPlanWidgetState();
  
}
class AllMembershipPlanWidgetState extends StateMVC<AllMembershipPlanWidget>{
  MyMembershipController _con;
  AllMembershipPlanWidgetState() : super(MyMembershipController()) {
    _con = controller;
  }
  int _selectedPlan = 0;

  @override
  void initState() {
    _con.listenForMembership();
    setState(() { });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
        title: Text(
          S.of(context).my_membership,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        bottom: PreferredSize(
            child: Container(
              color: Theme.of(context).hintColor.withOpacity(0.2),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      bottomNavigationBar:  Visibility(
        visible:  _con.subscriptionPlanList.isNotEmpty,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 55),
          padding: EdgeInsets.only(bottom: 20,top: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor.withOpacity(1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                for(int i=0; i< _con.subscriptionPlanList.length; i++){
                  if(_selectedPlan == i){
                    Navigator.of(context).pushNamed('/SubscriptionsPayment', arguments:_con.subscriptionPlanList.elementAt(i).id);
                  }
                }
              },
              padding: EdgeInsets.symmetric(vertical: 12),
              shape: StadiumBorder(),
              child: Text(
                S.of(context).pay_now,
                style: Theme.of(context).textTheme.headline6.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
      ),
      body: _con.subscriptionPlanList.isEmpty?Center(child: CircularProgressIndicator()): ListView.builder(
        shrinkWrap: true,
        itemCount: _con.subscriptionPlanList.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2)),
                ],
              ),
              child: GestureDetector(
                onTap: (){
                  for (int i = 0; i < _con.subscriptionPlanList.length; i++) {
                    _con.subscriptionPlanList[i].isRadioSelected = false;
                  }
                  _selectedPlan = index ;
                  _con.subscriptionPlanList[index].isRadioSelected  = true;
                  setState(() {
                  });
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  horizontalTitleGap: 15,
                  title:  Row(
                    children: [
                      Text(
                        _con.subscriptionPlanList[index].subscription_duration + " " + _con.subscriptionPlanList[index].subscription_type,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Exclusive Access",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400, color: Theme.of(context).accentColor.withOpacity(0.5)),
                          ),
                        ),
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _con.subscriptionPlanList[index].description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Helper.getPrice(
                            double.parse(_con.subscriptionPlanList[index].amount),
                            context,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Radio(
                    value: index,
                    groupValue: _selectedPlan,
                    activeColor: Theme.of(context).buttonColor,
                    onChanged: (Object value) {
                      for (int i = 0; i < _con.subscriptionPlanList.length; i++) {
                        _con.subscriptionPlanList[i].isRadioSelected = false;
                      }
                      _selectedPlan = value ;
                      _con.subscriptionPlanList[index].isRadioSelected  = true;
                      setState(() {
                      });
                    },
                  ),

                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
  
}