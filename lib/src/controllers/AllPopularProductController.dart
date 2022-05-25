import '../models/product.dart';
import '../repository/market_repository.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class AllPopularProductController extends ControllerMVC {
  List<Product> popularProducts = <Product>[];

  AllPopularProductController() {
    listenForPopularProducts();
  }

  Future<void> listenForPopularProducts() async {

    final Stream<Product> stream = await getPopularMarkets(deliveryAddress.value, "");
    stream.listen((Product _product) {
      setState(() => popularProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshAllTrendingProduct() async {
    setState(() {
      popularProducts = <Product>[];
    });
    await listenForPopularProducts();
  }
}