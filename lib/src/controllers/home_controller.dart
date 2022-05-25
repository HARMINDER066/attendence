import 'package:eighttoeightneeds/generated/l10n.dart';
import 'package:eighttoeightneeds/src/models/categorized_products.dart';
import 'package:eighttoeightneeds/src/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/slide.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/slider_repository.dart';
import '../models/address.dart' as model;
import '../repository/user_repository.dart' as userRepo;

class HomeController extends ControllerMVC {
  List<Category> categories = <Category>[];
  List<Slide> slides = <Slide>[];
  List<Market> topMarkets = <Market>[];
  List<Product> popularProducts = <Product>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];
  List<CategorizedProducts> categorizedProducts = <CategorizedProducts>[];

  HomeController() {
    listenForTopMarkets();
    listenForSlides();
    listenForTrendingProducts();
    listenForCategories();
    listenForPopularMarkets();
    listenForCategorizedProducts();
    // listenForRecentReviews();
  }

  Future<void> listenForSlides() async {
    final Stream<Slide> stream = await getSlides();
    stream.listen((Slide _slide) {
      setState(() => slides.add(_slide));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories("9");
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopMarkets() async {
    final Stream<Market> stream = await getNearMarkets(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Market _market) {
      setState(() => topMarkets.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularMarkets() async {
    final Stream<Product> stream = await getPopularMarkets(deliveryAddress.value, "6");
    stream.listen((Product _market) {
      setState(() => popularProducts.add(_market));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForTrendingProducts() async {

    final Stream<Product> stream = await getTrendingProducts(deliveryAddress.value, "6");
    stream.listen((Product _product) {
      setState(() => trendingProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForCategorizedProducts() async {
    final Stream<CategorizedProducts> stream = await getCategorizedProducts(deliveryAddress.value,);
    stream.listen((CategorizedProducts _product) {
      setState(() => categorizedProducts.add(_product));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(state.context);
    Overlay.of(state.context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  void requestForInitialCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(state.context);
    Overlay.of(state.context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      // if(currentUser.value.apiToken != null && _address !=null){
      //   addAddress(_address);
      // }
      setState(() { });
      // await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      slides = <Slide>[];
      categories = <Category>[];
      topMarkets = <Market>[];
      popularProducts = <Product>[];
      // recentReviews = <Review>[];
      trendingProducts = <Product>[];
      categorizedProducts = <CategorizedProducts>[];
    });
    await listenForSlides();
    await listenForTopMarkets();
    await listenForTrendingProducts();
    await listenForCategories();
    await listenForPopularMarkets();
    await listenForCategorizedProducts();
    // await listenForRecentReviews();
  }


  void addAddress(model.Address address) {
    userRepo.addAddress(address).then((value) {
      setState(() {
      });
    });
  }
}
