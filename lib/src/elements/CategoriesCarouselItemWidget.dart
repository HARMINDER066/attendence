import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/category.dart';
import '../models/route_argument.dart';

class CategoriesCarouselItemWidget extends StatelessWidget {
  double marginLeft;
  Category category;
  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).pushNamed('/Category', arguments: RouteArgument(id: category.id, param: category.name), );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: category.id,
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 10, end: 10),
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Theme.of(context).focusColor.withOpacity(0.3)),
                    boxShadow: [BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 7.0)]),
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
          SizedBox(height: 5),
          Expanded(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 10, end: 10),
              child: Text(
                category.name,
                softWrap: true,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Theme.of(context).accentColor.withOpacity(0.8), height: 1.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
