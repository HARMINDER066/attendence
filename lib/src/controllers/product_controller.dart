import 'package:eighttoeightneeds/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/option.dart';
import '../models/product.dart';
import '../repository/cart_repository.dart';
import '../repository/product_repository.dart';
import 'cart_controller.dart';
import '../repository/user_repository.dart' as userRepo;

ValueNotifier<int> favouriteProduct = ValueNotifier<int>(0);
class ProductController extends ControllerMVC {
  Product product;
  double quantity = 0;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  int current = 0;
  GlobalKey<ScaffoldState> scaffoldKey;
  CartController controller = CartController();

  ProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // listenForCart();
  }

  void listenForProduct({String productId, String message}) async {
    final Stream<Product> stream = await getProduct(productId);
    stream.listen((Product _product) {
      setState(() => product = _product);
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
        behavior: SnackBarBehavior.floating,
      ));
    }, onDone: () {
      calculateTotal(product);
    });
  }

  void listenForFavorite({String productId}) async {
    final Stream<Favorite> stream = await isFavoriteProduct(productId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      setState(() {
        carts.add(_cart);
      });
    });
  }

  bool isSameMarkets(Product product) {
    if (carts.isNotEmpty) {
      print( carts[0].product?.market?.id);
      print(product.market?.id);
      return carts[0].product?.market?.id == product.market?.id;
    }else{
      return true;
    }
  }

  void addToCart(Product product, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.options = product.options.where((element) => element.checked).toList();
    if(_newCart.options.isNotEmpty){
      for(int i= 0;i<_newCart.options.length;i++){
        _newCart.product = product;
        _newCart.product.price = _newCart.options[i].price;
      }
    }else{
      _newCart.product = product;
    }

    if(this.quantity ==0.0){
      this.quantity=1.0;
    }

    _newCart.quantity = this.quantity;

    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {

      // if(_oldCart.quantity>=this.quantity){
      //   _oldCart.quantity += this.quantity;
      // }else{
      //   _oldCart.quantity = this.quantity;
      // }
      _oldCart.quantity = this.quantity;

      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {

        // listenForCart();

      });
    } else {
      // the product doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        // listenForCart();
        listenForCartsCount();
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart), orElse: () => null);
  }

  void addToFavorite(Product product) async {
    var _favorite = new Favorite();
    _favorite.product = product;
    _favorite.options = product.options.where((Option _option) {
      return _option.checked;
    }).toList();

    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
    });
  }

  Future<void> refreshProduct() async {
    var _id = product.id;
    product = new Product();
    await listenForProduct(productId: _id, message: S.of(state.context).productRefreshedSuccessfuly);
    await listenForFavorite(productId: _id);
  }

  void calculateTotal(Product product) {
    total = product?.price ?? 0;
    product?.options?.forEach((option) {
      if(option.checked){
        total= 0;
      }else{
      }
      total += option.checked ? option.price : 0;
    });
    total *= quantity==0.0?1.0:quantity;
    setState(() {});

  }

  incrementQuantity(Product product) {
    if(this.quantity >= product.input_quantity && product.manage_quantity == 1.0)
      {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text('You Can Not Purchase More Than ${product.input_quantity.toInt().toString()}' + ' Quantity'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    else {
      if (this.quantity <= 99) {
        ++this.quantity;
        calculateTotal(product);
        if (isSameMarkets(product)) {
          addToCart(product);
        } else {
          addToCart(product, reset: false);
        }
        setState(() {});
      }
    }
  }

  decrementQuantity(Product product) {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal(product);
      if (isSameMarkets(product)) {
        addToCart(product);
      } else {
        addToCart(product, reset: false);
      }
      setState(() { });
    }else if(this.quantity == 1.0){
      this.quantity=0;
      User _user = userRepo.currentUser.value;

      if(product.product_carts.isNotEmpty){
        for(int i=0;i<product.product_carts.length;i++){
          if(product.id == product.product_carts.elementAt(i).product_id && _user.id == product.product_carts.elementAt(i).user_id){

            ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
              content: Text(S.of(state.context).the_product_was_removed_from_your_cart(product.name)),
              behavior: SnackBarBehavior.floating,
            ));
            removeProductCart(product.product_carts.elementAt(i).id).then((value) {
              calculateTotal(product);
              listenForCartsCount();
            });
          }
        }
      }
      setState(() { });
    }
  }

  void listenForCartsCount() async {

    final Stream<int> stream = await getCartCount();
    stream.listen((int _count) {
      setState(() {
        cartCount.value = _count;
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }
}
