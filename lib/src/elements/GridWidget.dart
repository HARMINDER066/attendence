import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/product.dart';

import '../elements/GridItemWidget.dart';

class GridWidget extends StatelessWidget {
  final List<Product> marketsList;
  final String heroTag;
  GridWidget({Key key, this.marketsList, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.4),
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric( horizontal: 15),
      child: new ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: marketsList.length,
        itemBuilder: (BuildContext context, int index) {
          return GridItemWidget(product: marketsList.elementAt(index), heroTag: heroTag);
        },
      ),
    );
  }
}
