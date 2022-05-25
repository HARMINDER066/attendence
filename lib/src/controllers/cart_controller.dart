import 'package:eighttoeightneeds/src/models/coupon_list.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/cart.dart';
import '../models/coupon.dart';
import '../repository/cart_repository.dart';
import '../repository/coupon_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

ValueNotifier<int> cartCount = ValueNotifier<int>(0);
class CartController extends ControllerMVC {
  List<Cart> carts = <Cart>[];
  List<CouponList> couponList = <CouponList>[];
  double taxAmount = 0.0;
  double deliveryFee = 0.0;
  double subTotal = 0.0;
  double total = 0.0;
  double particularProductTotal = 0.0;
  GlobalKey<ScaffoldState> scaffoldKey;
  bool selectedPickup = false;
  double appliedCouponDiscountPrice = 0.0;

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForCarts({String message}) async {
    carts.clear();
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      if (!carts.contains(_cart)) {
        setState(() {
          coupon = _cart.product.applyCoupon(coupon);
          carts.add(_cart);
        });
      }
    }, onError: (a) {
      print(a);
      print("listenForCart--> ${a}");
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(state.context).verify_your_internet_connection),
      //   behavior: SnackBarBehavior.floating,
      // ));
    }, onDone: () {
      if (carts.isNotEmpty) {
        calculateSubtotal();
      }
      if (message != null) {
        // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        //   content: Text(message),
        // ));
      }
      onLoadingCartDone();
    });
  }

  void onLoadingCartDone() {}

  void listenForCartsCount({String message}) async {
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

  void listenForCoupon() async {
    couponList.clear();
    // OverlayEntry loader = Helper.overlayLoader(state.context);
    // Overlay.of(state.context).insert(loader);
    final Stream<CouponList> stream = await getCouponList();
    stream.listen((CouponList _couponList) {
      setState(() {
        couponList.add(_couponList);
      });
    }, onError: (a) {
      // loader.remove();
      print(a);
    }).onDone(() {
      // loader.remove();
    });
  }

  Future<void> refreshCarts() async {
    setState(() {
      carts = [];
      couponList = [];
    });
    listenForCarts(message: S.of(state.context).carts_refreshed_successfuly);
    listenForCoupon();
  }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
    });
    removeCart(_cart).then((value) {
      calculateSubtotal();
      // ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
      //   content: Text(S.of(state.context).the_product_was_removed_from_your_cart(_cart.product.name)),
      //   behavior: SnackBarBehavior.floating,
      // ));
    });
  }

  void calculateSubtotal() async {
    double cartPrice = 0;
    subTotal = 0;
    carts.forEach((cart) {
      cartPrice = cart.product.price;
      cart.options.forEach((element) {
        if(element.checked){
          cartPrice= 0.0;
        }else{
          cartPrice= 0.0;
        }
        cartPrice += element.price;
      });

      appliedCouponDiscountPrice += cart.product.couponDiscountPrice;

      cartPrice *= cart.quantity;
      subTotal += cartPrice;
    });

    if(carts.isNotEmpty){
      if (Helper.canDelivery(carts[0].product.market, carts: carts)) {

        //new added for subscriber user minus delivery fees
        if(carts[0].subs_user_status == 1){
          if(subTotal>carts[0].min_order_amount){
            deliveryFee = 0.0;
          }else{
            deliveryFee = carts[0].product.market.deliveryFee;
          }
        }else if(carts[0].subs_user_status == 0){
          if(subTotal>carts[0].product.market.order_below){
            deliveryFee = 0.0;
          }else{
            deliveryFee = carts[0].product.market.deliveryFee;
          }
        }else{
          deliveryFee = carts[0].product.market.deliveryFee;
        }

        // deliveryFee = carts[0].product.market.deliveryFee;
      }
      // taxAmount = (subTotal + deliveryFee) * carts[0].product.market.defaultTax / 100;
      if(selectedPickup){
        taxAmount = (subTotal) * carts[0].product.market.defaultTax / 100;
      }else{
        taxAmount = (subTotal+deliveryFee) * carts[0].product.market.defaultTax / 100;
      }

      total = subTotal + taxAmount + deliveryFee;
    }

    setState(() {});
  }

  void doApplyCoupon(String code, {String message}) async {
    setState(() {appliedCouponDiscountPrice = 0.0;});
    OverlayEntry loader = Helper.overlayLoader(state.context);
    Overlay.of(state.context).insert(loader);
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      loader.remove();
      print(a);
    }, onDone: () {
      loader.remove();
      listenForCarts();
    });
  }

  void doRemoveCoupon(String code, {String message}) async {
    setState(() {appliedCouponDiscountPrice = 0.0;});
    coupon = new Coupon.fromJSON({"code": code, "valid": null});
    final Stream<Coupon> stream = await verifyCoupon(code);
    stream.listen((Coupon _coupon) async {
      coupon = _coupon;
    }, onError: (a) {
      print(a);
    }, onDone: () {
      listenForCarts();
    });
  }

  incrementQuantity(Cart cart) {
    if(cart.quantity >= cart.product.input_quantity && cart.product.manage_quantity == 1.0)
    {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text('You Can Not Purchase More Than ${cart.product.input_quantity.toInt().toString()}' + ' Quantity'),
        behavior: SnackBarBehavior.floating,
      ));
    }
    else {
    if (cart.quantity <= 99) {
      ++cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      --cart.quantity;
      updateCart(cart);
      calculateSubtotal();
    }
  }

  void goCheckout(BuildContext context) {
    if (!currentUser.value.profileCompleted()) {
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).completeYourProfileDetailsToContinue),
        action: SnackBarAction(
          label: S.of(state.context).settings,
          textColor: Theme.of(state.context).primaryColor,
          onPressed: () {
            Navigator.of(state.context).pushNamed('/Settings');
          },
        ),
      ));
    } else {
      if (carts[0].product.market.closed) {
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_market_is_closed_),
        ));
      } else {
        Navigator.of(state.context).pushNamed('/DeliveryPickup');
      }
    }
  }

  Color getCouponIconColor() {
    if (coupon?.valid == true) {
      return Colors.green;
    } else if (coupon?.valid == false) {
      return Colors.redAccent;
    }
    return Theme.of(state.context).focusColor.withOpacity(0.7);
  }
}
