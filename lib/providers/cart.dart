import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem({String productId, double price, String title, String imageUrl}){
    if(_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          imageUrl: imageUrl,
        )
      );
    }
    else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
            imageUrl: imageUrl,
          )
      );
    }
    notifyListeners();
  }

  int get cartItemCount {
    return _items.length;
  }

  double get cartTotalAmount {
    var total = 0.0;

    _items.forEach((key, cartItem){
      total += (cartItem.price * cartItem.quantity);
    });

    return total;
  }

  void removeItem(String itemId){
    _items.remove(itemId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId)){
      return;
    }

    if(_items[productId].quantity > 1){
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity - 1,
        imageUrl: existingCartItem.imageUrl,
      ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

}