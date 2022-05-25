import '../models/product.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AllTrendingProductController extends ControllerMVC {

  List<Product> trendingProducts = <Product>[];

  AllTrendingProductController() {
    listenForTrendingProducts();
  }

  Future<void> listenForTrendingProducts() async {

    final Stream<Product> stream = await getTrendingProducts(deliveryAddress.value, "");
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshAllTrendingProduct() async {
    setState(() {
      trendingProducts = <Product>[];
    });
    await listenForTrendingProducts();
  }

}