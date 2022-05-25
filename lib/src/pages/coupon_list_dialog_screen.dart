import 'package:cached_network_image/cached_network_image.dart';
import 'package:eighttoeightneeds/generated/l10n.dart';
import 'package:eighttoeightneeds/src/helpers/helper.dart';
import 'package:eighttoeightneeds/src/models/coupon_list.dart';
import 'package:flutter/material.dart';

class CouponListDialogScreen extends StatefulWidget{

  List<CouponList> couponList;
  CouponListDialogScreen({Key key, this.couponList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CouponListDialogScreenState();
  }
  
}
class CouponListDialogScreenState extends State<CouponListDialogScreen>{
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 35,
      backgroundColor: Colors.transparent,
      child: dropDownBox(context),
    );
  }

  dropDownBox(context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.45,
          padding: EdgeInsets.only(top: 15, bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.couponList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, widget.couponList[index].code);
                  },
                  child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child:  CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 60,
                                  width: 60,
                                  imageUrl: widget.couponList[index].couponImage,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/img/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.couponList[index].code,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle1.merge(TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.w400,)),
                                ),
                                Text(
                                    widget.couponList[index].description != null &&  widget.couponList[index].description != ""?
                                  Helper.skipHtml( widget.couponList[index].description):"Apply this coupon to get "+ (widget.couponList[index].discount_type=="fixed"? "Flat ${widget.couponList[index].discount.toInt()} Rs. off" : "${widget.couponList[index].discount.toInt()}% off")+" discount",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Divider(
                          color: Theme.of(context).dividerColor.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: new IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.close, color: Theme.of(context).hintColor),
            onPressed: () => {
              Navigator.of(context).pop(""),
            },
          ),
        ),
      ],
    );
  }
  
}