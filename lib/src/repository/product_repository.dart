import 'dart:convert';
import 'dart:io';

import 'package:eighttoeightneeds/src/models/categorized_products.dart';
import 'package:eighttoeightneeds/src/repository/settings_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Product>> getTrendingProducts(Address address, String type) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  filter.delivery = false;
  filter.open = false;
  _queryParams['limit'] = type;
  _queryParams['trending'] = 'week';

  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  // _queryParams.addAll(filter.toQuery());

  _queryParams['with'] = 'market;category;options;optionGroups;productReviews;productReviews.user';
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';
  uri = uri.replace(queryParameters: _queryParams);
  // uri = uri_.replace(queryParameters: {'with': 'market;category;options;optionGroups;productReviews;productReviews.user'});

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProduct(String productId) async {
  Uri uri = Helper.getUri('api/products/$productId');
  print("product url is ${uri}");
  Map<String, dynamic> _queryParams = {};
  _queryParams['with'] = 'market;category;options;optionGroups;productReviews;productReviews.user';
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    print(uri);
    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
        return Product.fromJSON(data);
      });
    }



  } catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> searchProducts(String search, Address address, String limit) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
  _queryParams['limit'] = limit;
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsByCategory(categoryId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'market';
  _queryParams['search'] = 'category_id:$categoryId';
  _queryParams['searchFields'] = 'category_id:=';
  _queryParams['with'] = 'market;category;options;optionGroups;productReviews;productReviews.user';
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';

  Address address = deliveryAddress.value;
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }

  // _queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  // uri = uri_.replace(queryParameters: {'with': 'market;category;options;optionGroups;productReviews;productReviews.user'});

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getProductsBySubCategory(categoryId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'market';
  _queryParams['search'] = 'sub_category_id:$categoryId';
  _queryParams['searchFields'] = 'sub_category_id:=';
  _queryParams['with'] = 'market;category;options;optionGroups;productReviews;productReviews.user';
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';

  Address address = deliveryAddress.value;
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }

  // _queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  // uri = uri_.replace(queryParameters: {'with': 'market;category;options;optionGroups;productReviews;productReviews.user'});

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Favorite>> isFavoriteProduct(String productId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/exist?${_apiToken}product_id=$productId&user_id=${_user.id}';

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) => Favorite.fromJSON(data));
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorites?${_apiToken}with=product;user;product.options;product.optionGroups&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  try {

    if(streamedRest != null){
      return streamedRest.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .map((data) => Helper.getData(data))
          .expand((data) => (data as List))
          .map((data) => Favorite.fromJSON(data));
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  // favorite.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites?$_apiToken';

  Map<String, dynamic> body = {
    "product_id": favorite.product.id,
    "user_id": _user.id,
  };
  try {
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(body),
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Stream<Product>> getProductsOfMarket(String marketId, {List<String> categories}) async {
  Uri uri = Helper.getUri('api/products/categories');
  Map<String, dynamic> query = {
    'with': 'market;category;options;optionGroups;productReviews',
    'search': 'market_id:$marketId',
    'searchFields': 'market_id:=',
    'user_id': '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}',
  };

  if (categories != null && categories.isNotEmpty) {
    query['categories[]'] = categories;
  }
  uri = uri.replace(queryParameters: query);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getTrendingProductsOfMarket(String marketId) async {
  Uri uri = Helper.getUri('api/products');

  Address address = deliveryAddress.value;

  uri = uri.replace(queryParameters: {
    'with': 'category;options;optionGroups;productReviews',
    'search': 'market_id:$marketId;featured:1',
    'user_id': '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}',
    'myLon':!address.isUnknown()?address.longitude.toString():'',
    'myLat':!address.isUnknown()?address.latitude.toString():'',
    'areaLon':!address.isUnknown()?address.longitude.toString():'',
    'areaLat':!address.isUnknown()?address.latitude.toString():'',
    // 'searchFields': 'market_id:=;featured:=',
    // 'searchJoin': 'and',
  });

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Stream<Product>> getFeaturedProductsOfMarket(String marketId) async {
  Uri uri = Helper.getUri('api/products');
  uri = uri.replace(queryParameters: {
    'with': 'category;options;productReviews',
    'search': 'market_id:$marketId;featured:1',
    'searchFields': 'market_id:=;featured:=',
    'searchJoin': 'and',
    'user_id': '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}',
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return Product.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Product.fromJSON({}));
  }
}

Future<Review> addProductReview(Review review, Product product) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}product_reviews';
  final client = new http.Client();
  review.user = userRepo.currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofProductToMap(product)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}

Future<bool> removeProductCart(String cart_id) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return false;
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}carts/${cart_id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );

  return Helper.getBoolData(json.decode(response.body));
}

Future<Stream<CategorizedProducts>> getCategorizedProducts(Address address) async {
  Uri uri = Helper.getUri('api/newProducts');
  Map<String, dynamic> _queryParams = {};

  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams['with'] = 'products.market;products.category;products.options;products.optionGroups;products.productReviews;products.productReviews.user';
  _queryParams['user_id'] = '${userRepo.currentUser.value.id == null?"":userRepo.currentUser.value.id}';
  uri = uri.replace(queryParameters: _queryParams);

  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    if(streamedRest != null){
      return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
        return CategorizedProducts.fromJSON(data);
      });
    }

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new CategorizedProducts.fromJSON({}));
  }
}
