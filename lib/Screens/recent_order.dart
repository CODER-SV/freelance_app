import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

final _firestore = FirebaseFirestore.instance;

class RecentOrder extends StatelessWidget {
  static const String id = 'recent_order';
  const RecentOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Recent Orders',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontStyle: FontStyle.normal,
            color: Color(0xffFFFFFF),
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_circle_left_rounded,
            color: Color(0xffFFFFFF),
            size: 45,
          ),
        ),
        backgroundColor: Color(0xff7C6565),
        toolbarHeight: 75,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Please log in to view your orders."));
            } else {
              final userId = snapshot.data!.uid;
              return OrderStream(userId: userId);
            }
          },
        ),
      ),
    );
  }
}

class OrderStream extends StatelessWidget {
  final String userId;
  const OrderStream({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore
              .collection('orders')
              .where('user_id', isEqualTo: userId)
              .orderBy('order_date', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff7C6565), // Brown loader
            ),
          );
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              "No recent orders",
              style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
              textAlign: TextAlign.center,
            ),
          );
        }

        return AnimatedListView(orders: orders);
      },
    );
  }
}

class AnimatedListView extends StatefulWidget {
  final List<QueryDocumentSnapshot> orders;
  const AnimatedListView({required this.orders, super.key});

  @override
  State<AnimatedListView> createState() => _AnimatedListViewState();
}

class _AnimatedListViewState extends State<AnimatedListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        final orderData = order.data() as Map<String, dynamic>;

        final orderNumber = orderData['order_number'].toString();
        final status = orderData['status'] ?? "Pending";
        final totalPrice = orderData['total_price'].toDouble();
        final orderTimestamp = orderData['order_date'] as Timestamp;
        final dateTime = DateFormat(
          'dd MMM yyyy HH:mm',
        ).format(orderTimestamp.toDate());
        final orderItems = orderData['order_items'] as List<dynamic>? ?? [];

        List<String> itemDetails = [];
        for (var item in orderItems) {
          final itemName = item['name'];
          final size = item['size'];
          final quantity = item['quantity'];
          final price = item['total_price'];
          itemDetails.add("$itemName ($size) x$quantity - Rs $price");
        }

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(
            opacity: _controller,
            child: OrderCard(
              orderId: order.id,
              orderNumber: orderNumber,
              status: status,
              totalPrice: totalPrice,
              dateTime: dateTime,
              items: itemDetails,
            ),
          ),
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String orderId;
  final String orderNumber;
  final String status;
  final double totalPrice;
  final String dateTime;
  final List<String> items;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    required this.dateTime,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Number and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #$orderNumber",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      status.toLowerCase() == "declined"
                          ? Colors.red[100]
                          : Colors.green[100], // Red if declined
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toLowerCase() == "declined"
                      ? "CANCELLED"
                      : status.toUpperCase(), // Show CANCELLED if declined
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        status.toLowerCase() == "declined"
                            ? Colors.red[700]
                            : Colors.green[700], // Text color red if declined
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.5, indent: 1, endIndent: 1),

          // List of items
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                items
                    .map(
                      (item) => Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )
                    .toList(),
          ),

          const SizedBox(height: 10),

          // Price and reorder button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: Rs $totalPrice",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: () async {
                  final firestore = FirebaseFirestore.instance;

                  try {
                    // Step 1: Fetch order document by ID
                    final docSnapshot =
                        await firestore.collection('orders').doc(orderId).get();

                    if (docSnapshot.exists) {
                      final orderData = docSnapshot.data()!;
                      final orderItems =
                          orderData['order_items'] as List<dynamic>;

                      final cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );

                      // Step 2: Clear existing cart before refill
                      cartProvider.clearCart();

                      // Step 3: Loop through each item and add to cart
                      for (var item in orderItems) {
                        final name = item['name'];
                        final size = item['size'];
                        final quantity = item['quantity'];
                        final price = item['price'];
                        final totalPrice = item['total_price'];
                        final image = item['image'];
                        final useDuplicate = item['useDuplicate'] ?? false;

                        if (useDuplicate) {
                          cartProvider.addToCart(
                            name: name,
                            size: size,
                            price: price,
                            image: image,
                            quantity: quantity,
                          );
                        } else {
                          cartProvider.addToCart(
                            name: name,
                            price: price,
                            image: image,
                            quantity: quantity,
                          );
                        }
                      }

                      // Step 4: Navigate to cart screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }
                  } catch (e) {
                    print("Error while reordering: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Something went wrong while reordering.'),
                      ),
                    );
                  }
                },

                child: const Row(
                  children: [
                    Text(
                      "Order again",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Order date and time
          Text(
            dateTime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: 'Kanit',
              fontStyle: FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}
