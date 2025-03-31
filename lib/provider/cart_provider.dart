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
    this.quantity = 1,
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
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  List<CartItem> cart = [];
  List<CartDuplicateItem> cartDuplicate = [];
  ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);
  void updateCartItemCount() {
    cartItemCount.value = totalItemsCount; // Update the count dynamically
  }

  /// **1️⃣ Add to Cart**
  void addToCart({
    required String name,
    required String image,
    required int price,
    String? size,
  }) {
    if (size != null) {
      // 🟢 Size-based duplicate items (CartDuplicate)
      final existingItem = cartDuplicate.firstWhere(
        (item) => item.name == name && item.size == size,
        orElse:
            () => CartDuplicateItem(name: "", image: "", size: "", price: 0),
      );

      if (existingItem.name.isNotEmpty) {
        repeatOrder(name: name, size: size);
      } else {
        cartDuplicate.add(
          CartDuplicateItem(
            name: name,
            image: image,
            size: size,
            price: price,
            quantity: 1,
          ),
        );
        updateCartItemCount();
        notifyListeners();
      }
    } else {
      // 🟢 Normal cart items (No size check)
      final existingItem = cart.firstWhere(
        (item) => item.name == name,
        orElse: () => CartItem(name: "", image: "", price: 0),
      );

      if (existingItem.name.isNotEmpty) {
        repeatOrder(name: name);
      } else {
        cart.add(CartItem(name: name, image: image, price: price, quantity: 1));
        notifyListeners();
        updateCartItemCount();
      }
    }
    printCartItems();
  }

  /// **2️⃣ Remove from Cart**
  void removeFromCart({required String name, String? size}) {
    if (size != null) {
      // 🟢 For size-based duplicate items
      for (var item in cartDuplicate) {
        if (item.name == name && item.size == size) {
          item.quantity--; // Decrease quantity
          if (item.quantity == 0) {
            cartDuplicate.remove(item); // Remove item if quantity is 0
          }
          notifyListeners();
          updateCartItemCount();
          return; // Exit after updating the item
        }
      }
    } else {
      // 🟢 For normal cart items
      for (var item in cart) {
        if (item.name == name) {
          item.quantity--; // Decrease quantity
          if (item.quantity == 0) {
            cart.remove(item); // Remove item if quantity is 0
          }
          notifyListeners();
          updateCartItemCount();
          return; // Exit after updating the item
        }
      }
    }
    printCartItems();
  }

  /// **3️⃣ Repeat Order (Increase Quantity)**
  void repeatOrder({required String name, String? size}) {
    if (size != null) {
      for (var item in cartDuplicate) {
        if (item.name == name && item.size == size) {
          item.quantity++;
          notifyListeners();
          updateCartItemCount();
          printCartItems();
          return;
        }
      }
    } else {
      for (var item in cart) {
        if (item.name == name) {
          item.quantity++;
          notifyListeners();
          updateCartItemCount();
          printCartItems();
          return;
        }
      }
    }
  }

  int getQuantity(String name, String? size) {
    // If size is null, search in cart
    if (size == null) {
      var existingItem = cart.firstWhere(
        (item) => item.name == name,
        orElse: () => CartItem(name: '', image: '', price: 0, quantity: 0),
      );
      return existingItem.quantity;
    }
    // Otherwise, search in cartDuplicate
    else {
      var existingItem = cartDuplicate.firstWhere(
        (item) => item.name == name && item.size == size,
        orElse:
            () => CartDuplicateItem(
              name: '',
              image: '',
              price: 0,
              size: '',
              quantity: 0,
            ),
      );
      return existingItem.quantity;
    }
  }

  void printCartItems() {
    print("Cart Items:");

    // Print normal cart items
    for (var item in cart) {
      print(
        'Name: ${item.name}, Quantity: ${item.quantity}, Price: ${item.price}, Image: ${item.image}',
      );
    }

    // Print size-based duplicate cart items
    for (var item in cartDuplicate) {
      print(
        'Name: ${item.name}, Size: ${item.size}, Quantity: ${item.quantity}, Price: ${item.price}, Image: ${item.image}',
      );
    }
  }

  /// **Get Total Items Count**
  int get totalItemsCount {
    int total = cart.fold(0, (sum, item) => sum + item.quantity);
    total += cartDuplicate.fold(0, (sum, item) => sum + item.quantity);
    return total;
  }

  double getTotalPrice() {
    double total = 0;

    // Normal cart items (without size)
    for (var item in cart) {
      total += item.price * item.quantity;
    }

    // Duplicate cart items (with size)
    for (var item in cartDuplicate) {
      total += item.price * item.quantity;
    }

    return total;
  }
}

// import 'package:flutter/foundation.dart';
//
// class CartItem {
//   final String name;
//   final String image;
//   final int price;
//   int quantity;
//
//   CartItem({
//     required this.name,
//     required this.image,
//     required this.price,
//     this.quantity = 1,
//   });
// }
//
// class CartDuplicateItem {
//   final String name;
//   final String image;
//   final String size;
//   final int price;
//   int quantity;
//
//   CartDuplicateItem({
//     required this.name,
//     required this.image,
//     required this.size,
//     required this.price,
//     this.quantity = 1,
//   });
// }
//
// class CartProvider extends ChangeNotifier {
//   List<CartItem> cart = [];
//   List<CartDuplicateItem> cartDuplicate = [];
//
//   /// **1️⃣ Add to Cart**
//   void addToCart({
//     required String name,
//     required String image,
//     required int price,
//     String? size,
//     required bool useDuplicate,
//   }) {
//     if (useDuplicate) {
//       // 🟢 Agar duplicate items allow hain (Size check hoga)
//       final existingItem = cartDuplicate.firstWhere(
//         (item) => item.name == name && item.size == size,
//         orElse:
//             () => CartDuplicateItem(name: "", image: "", size: "", price: 0),
//       );
//
//       if (existingItem.name.isNotEmpty) {
//         // ✅ Size bhi same hai → Quantity badhao
//         repeatOrder(name: name, size: size, useDuplicate: true);
//       } else {
//         // 🔹 Naya item add karo
//         cartDuplicate.add(
//           CartDuplicateItem(
//             name: name,
//             image: image,
//             size: size!,
//             price: price,
//             quantity: 1,
//           ),
//         );
//         notifyListeners();
//       }
//     } else {
//       // 🟢 Normal cart ke liye (Without size check)
//       final existingItem = cart.firstWhere(
//         (item) => item.name == name,
//         orElse: () => CartItem(name: "", image: "", price: 0),
//       );
//
//       if (existingItem.name.isNotEmpty) {
//         // ✅ Already present hai → Repeat order
//         repeatOrder(name: name, useDuplicate: false);
//       } else {
//         // 🔹 Naya item add karo
//         cart.add(CartItem(name: name, image: image, price: price, quantity: 1));
//         notifyListeners();
//       }
//     }
//   }
//
//   /// **2️⃣ Remove from Cart**
//   void removeFromCart({
//     required String name,
//     String? size,
//     required bool useDuplicate,
//   }) {
//     if (useDuplicate) {
//       // 🟢 Duplicate list se remove karna hai
//       cartDuplicate.removeWhere(
//         (item) => item.name == name && item.size == size,
//       );
//     } else {
//       // 🟢 Normal list se remove karna hai
//       cart.removeWhere((item) => item.name == name);
//     }
//     notifyListeners();
//   }
//
//   /// **3️⃣ Repeat Order (Increase Quantity)**
//   void repeatOrder({
//     required String name,
//     String? size,
//     required bool useDuplicate,
//   }) {
//     if (useDuplicate) {
//       for (var item in cartDuplicate) {
//         if (item.name == name && item.size == size) {
//           item.quantity++;
//           notifyListeners();
//           return;
//         }
//       }
//     } else {
//       for (var item in cart) {
//         if (item.name == name) {
//           item.quantity++;
//           notifyListeners();
//           return;
//         }
//       }
//     }
//   }
//
//   /// **Get Total Items Count**
//   int get totalItemsCount {
//     int total = cart.fold(0, (sum, item) => sum + item.quantity);
//     total += cartDuplicate.fold(0, (sum, item) => sum + item.quantity);
//     return total;
//   }
// }
