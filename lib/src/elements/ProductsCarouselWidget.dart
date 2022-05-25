import 'package:flutter/material.dart';

import '../elements/ProductsCarouselItemWidget.dart';
import '../elements/ProductsCarouselLoaderWidget.dart';
import '../models/product.dart';

class ProductsCarouselWidget extends StatelessWidget {
  final List<Product> productsList;
  final String heroTag;

  ProductsCarouselWidget({Key key, this.productsList, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return productsList.isEmpty
        ? ProductsCarouselLoaderWidget()
        : Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.4),
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.symmetric( horizontal: 15),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                return ProductsCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  product: productsList.elementAt(index),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
