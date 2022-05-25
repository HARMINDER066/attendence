import 'package:flutter/material.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? CircularLoadingWidget(height: 150)
        : Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GridView.count(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              shrinkWrap: true,
              children: List.generate(this.categories.length, (index) {
                return new CategoriesCarouselItemWidget(
                          marginLeft: 0,
                          category: this.categories.elementAt(index),
                        );
              }),
            ),
    );
  }
}
