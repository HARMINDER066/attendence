import '../models/category.dart';
import '../repository/category_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';

class SearchController extends ControllerMVC {
  List<Market> markets = <Market>[];
  List<Product> products = <Product>[];
  List<Category> categories = <Category>[];
  bool isMarketGet = true;
  bool isProductGet = true;
  bool isCategoriesGet = true;

  SearchController() {
    listenForMarkets(limit: "5");
    listenForProducts(limit: "5");
    listenForCategories(limit: "5");
  }

  void listenForMarkets({String search, String limit}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Market> stream = await searchMarkets(search, _address, limit);
    stream.listen((Market _market) {
      isMarketGet = false;
      setState(() => markets.add(_market));
    }, onError: (a) {
      setState(() {isMarketGet = false;});
      print(a);
    }, onDone: () {
      setState(() {isMarketGet = false;});
    });
  }

  void listenForProducts({String search, String limit}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Product> stream = await searchProducts(search, _address, limit);
    stream.listen((Product _product) {
      isProductGet = false;
      setState(() => products.add(_product));
    }, onError: (a) {
      setState(() {isProductGet = false;});
      print(a);
    }, onDone: () {
      setState(() {isProductGet = false;});
    });
  }

  Future<void> listenForCategories({String search, String limit}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Category> stream = await searchCategories(search, _address, limit);
    stream.listen((Category _category) {
      isCategoriesGet = false;
      setState(() => categories.add(_category));
    }, onError: (a) {
      setState(() {isCategoriesGet = false;});
      print(a);
    }, onDone: () {
      setState(() {isCategoriesGet = false;});
    });
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      markets = <Market>[];
      products = <Product>[];
      categories = <Category>[];
      isMarketGet = true;
      isProductGet = true;
      isCategoriesGet = true;
    });
    listenForMarkets(search: search, limit: "50");
    listenForProducts(search: search, limit: "50");
    listenForCategories(search: search, limit: "50");
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
