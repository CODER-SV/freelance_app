import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String image;
  final int price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });
}

class CartDuplicateItem {
  final String name;
  final String image;
  final String size;
  final int price;
  int quantity;

  CartDuplicateItem({
    required this.name,
    required this.image,
    required this.size,
    required this.price,
    required this.quantity,
  });
}

class LocationProvider with ChangeNotifier {
  String? _selectedLocation;

  String? get selectedLocation => _selectedLocation;

  void setLocation(String location) {
    _selectedLocation = location;
    notifyListeners();
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> cart = [];
  List<CartDuplicateItem> cartDuplicate = [];
  ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  void updateCartItemCount() {
    cartItemCount.value = totalItemsCount;
  }

  void addToCart({
    required String name,
    required String image,
    required int price,
    String? size,
    int quantity = 1, // <-- Add this line
  }) {
    if (size != null) {
      final index = cartDuplicate.indexWhere(
        (item) => item.name == name && item.size == size,
      );
      if (index != -1) {
        cartDuplicate[index].quantity += quantity;
      } else {
        cartDuplicate.add(
          CartDuplicateItem(
            name: name,
            image: image,
            size: size,
            price: price,
            quantity: quantity, // <-- Use passed quantity
          ),
        );
      }
    } else {
      final index = cart.indexWhere((item) => item.name == name);
      if (index != -1) {
        cart[index].quantity += quantity;
      } else {
        cart.add(
          CartItem(
            name: name,
            image: image,
            price: price,
            quantity: quantity, // <-- Use passed quantity
          ),
        );
      }
    }

    updateCartItemCount();
    notifyListeners();
    printCartItems();
  }

  void removeFromCart({required String name, String? size}) {
    if (size != null) {
      final index = cartDuplicate.indexWhere(
        (item) => item.name == name && item.size == size,
      );
      if (index != -1) {
        final item = cartDuplicate[index];
        item.quantity--;
        if (item.quantity == 0) {
          cartDuplicate.removeAt(index);
        }
        updateCartItemCount();
        notifyListeners();
      }
    } else {
      final index = cart.indexWhere((item) => item.name == name);
      if (index != -1) {
        final item = cart[index];
        item.quantity--;
        if (item.quantity == 0) {
          cart.removeAt(index);
        }
        updateCartItemCount();
        notifyListeners();
      }
    }
    printCartItems();
  }

  void repeatOrder({required String name, String? size}) {
    if (size != null) {
      final index = cartDuplicate.indexWhere(
        (item) => item.name == name && item.size == size,
      );
      if (index != -1) {
        cartDuplicate[index].quantity++;
        updateCartItemCount();
        notifyListeners();
        printCartItems();
      }
    } else {
      final index = cart.indexWhere((item) => item.name == name);
      if (index != -1) {
        cart[index].quantity++;
        updateCartItemCount();
        notifyListeners();
        printCartItems();
      }
    }
  }

  int getQuantity(String name, String? size) {
    if (size == null) {
      final index = cart.indexWhere((item) => item.name == name);
      return index != -1 ? cart[index].quantity : 0;
    } else {
      final index = cartDuplicate.indexWhere(
        (item) => item.name == name && item.size == size,
      );
      return index != -1 ? cartDuplicate[index].quantity : 0;
    }
  }

  void printCartItems() {
    print("Cart Items:");
    for (var item in cart) {
      print(
        'Name: ${item.name}, Quantity: ${item.quantity}, Price: ${item.price}, Image: ${item.image}',
      );
    }
    for (var item in cartDuplicate) {
      print(
        'Name: ${item.name}, Size: ${item.size}, Quantity: ${item.quantity}, Price: ${item.price}, Image: ${item.image}',
      );
    }
  }

  int get totalItemsCount {
    int total = cart.fold(0, (sum, item) => sum + item.quantity);
    total += cartDuplicate.fold(0, (sum, item) => sum + item.quantity);
    return total;
  }

  void clearCart() {
    cart.clear();
    cartDuplicate.clear();
    cartItemCount.value = 0;
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in cart) {
      total += item.price * item.quantity;
    }
    for (var item in cartDuplicate) {
      total += item.price * item.quantity;
    }
    return total;
  }
}
