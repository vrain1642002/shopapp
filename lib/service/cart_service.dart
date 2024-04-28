import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  // Using Map to store the cart data, where the key is the product ID, and the value is the quantity.
  Map<int, int> cart = {};

  // Singleton instance of CartService
  static final CartService _instance = CartService._internal();

  factory CartService() {
    return _instance;
  }

  CartService._internal();

  void addToCart(int productId, {int quantity = 1}) {
    if (cart.containsKey(productId)) {
      // If the product is already in the cart, update the quantity.
      cart[productId] = cart[productId]! + quantity;
    } else {
      // If the product is not in the cart, add it with the specified quantity.
      cart[productId] = quantity;
    }
    // Save the updated cart to local storage.
    saveCartToLocalStorage();
  }

  void updateCartQuantity(int productId, int newQuantity) {
    if (cart.containsKey(productId)) {
      cart[productId] = newQuantity;
      saveCartToLocalStorage();
    }
  }

  Map<int, int> getCart() {
    return cart;
  }

  Future<void> saveCartToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the cart to a List<MapEntry<int, int>> before saving
    List<MapEntry<int, int>> cartEntries = cart.entries.toList();

    // Convert the List<MapEntry<int, int>> to List<String>
    List<String> cartStringList = cartEntries
        .map((entry) =>
            '{"productID": ${entry.key}, "quantity": ${entry.value}}')
        .toList();

    // Save the List<String> to SharedPreferences
    prefs.setStringList('cart', cartStringList);
  }

  Future<void> loadCartFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartStringList = prefs.getStringList('cart');

    if (cartStringList != null) {
      // Convert List<String> back to List<MapEntry<int, int>>
      List<MapEntry<int, int>> cartEntries = cartStringList.map((entryString) {
        Map<String, dynamic> entryMap = jsonDecode(entryString);
        return MapEntry<int, int>(entryMap['productID'], entryMap['quantity']);
      }).toList();

      // Convert List<MapEntry<int, int>> to Map<int, int>
      cart = Map<int, int>.fromEntries(cartEntries);
    }
  }

  void clearCart() {
    cart.clear();
    saveCartToLocalStorage();
  }

  void setCart(Map<int, int> newCart) {
    cart = newCart;
    saveCartToLocalStorage();
  }

  void removeProductFromCart(int productId) {
    cart.remove(productId);
    saveCartToLocalStorage();
  }
}
