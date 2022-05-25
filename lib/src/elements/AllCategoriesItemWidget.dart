import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category.dart';
import '../models/route_argument.dart';

class AllCategoriesItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  AllCategoriesItemWidget({Key key, this.marginLeft, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id: category.id, param: category.name));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                tag: category.id,
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                  width: 100,
                  height: 100,
                  // decoration: BoxDecoration(
                  //     color: Theme.of(context).primaryColor,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.3)),
                  //     boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 7.0)]),
                  child: category.image.url.toLowerCase().endsWith('.svg')
                      ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SvgPicture.network(
                      category.image.url,
                      color: Theme.of(context).accentColor,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: category.image.icon,
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
                        category.name,
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(fontSize: 17,color: Theme.of(context).accentColor, fontWeight: FontWeight.w600))
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        category.description,
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
    );
  }
}