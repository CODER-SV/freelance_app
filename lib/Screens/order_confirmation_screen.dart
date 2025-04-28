import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:nescafe_flutter/Screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../Components/roundedButton.dart';
import '../provider/cart_provider.dart';

class OrderConfirmationScreen extends StatefulWidget {
  static const String id = 'order_confirmation_screen';
  late final String orderId;
  OrderConfirmationScreen({super.key, required this.orderId});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  double containerHeight = 64;
  double imageTop = 19;
  double textOpacity = 0.0;

  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get()
        .then((DocumentSnapshot doc) {
          if (doc.exists) {
            setState(() {
              orderData = doc.data() as Map<String, dynamic>;
            });
          }
        });

    // Animation delay as before
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        containerHeight = 125;
        imageTop = 80;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          textOpacity = 1.0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (orderData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final orderTimestamp = orderData!['order_date'] as Timestamp;
    final dateTime = DateFormat(
      'dd MMM yyyy HH:mm',
    ).format(orderTimestamp.toDate());
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.cart; // Items without size
    var cartDuplicateItems = cartProvider.cartDuplicate;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isCartEmpty = cartItems.isEmpty && cartDuplicateItems.isEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Order Confirmation',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontStyle: FontStyle.normal,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 75,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  // ✅ Animated Container for height
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: containerHeight,
                    width: double.infinity,
                    color: Color(0xff1DAF06).withOpacity(0.69),
                    child: Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 800),
                        opacity: textOpacity,
                        child: SizedBox(
                          height: 48,
                          width: 236,
                          child: Text(
                            "${orderData?['customer_name'].toString()} your order is confirmed!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w100,
                              fontFamily: 'Kanit',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ✅ Animated Positioned Image
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    top: imageTop,
                    left: 16,
                    child: Container(
                      width: 103,
                      height: 91,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/confirm.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 360,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Order Details :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 8),

                  Divider(),

                  SizedBox(height: 12),

                  // Order info
                  Text(
                    'Order no. : ${orderData?['order_number'].toString()}',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Order Id : ${widget.orderId}',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Order Date : $dateTime',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Item, Quantity, Price headings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Item',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Quantity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),

                  Divider(),

                  // Item 1
                  Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    height: 120,
                    child: ListView.builder(
                      itemCount:
                          context.watch<CartProvider>().cart.length +
                          context.watch<CartProvider>().cartDuplicate.length,
                      itemBuilder: (context, index) {
                        if (index < cartItems.length) {
                          // Fetch from cart (items without size)
                          final item = cartItems[index];
                          return orderList(
                            item.name,
                            'Rs ${item.price * item.quantity}', // Price * Quantity
                            'Regular',
                            item.quantity,
                          );
                        } else {
                          // Fetch from cartDuplicate (items with size)
                          final item =
                              cartDuplicateItems[index - cartItems.length];
                          return orderList(
                            item.name,
                            'Rs ${item.price * item.quantity}', // Price * Quantity
                            item.size,
                            item.quantity,
                          );
                        }
                      },
                    ),
                  ),

                  Divider(),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        'Rs ${context.watch<CartProvider>().getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Image.asset('assets/images/image 6.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedButton(
                  text: 'NEXT',
                  colour: Color(0xff7C6565),
                  textColour: Colors.white,
                  onPressed: () async {
                    // ✅ Clear cart before redirecting
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).clearCart();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoadingScreen()),
                    );
                  },
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class orderList extends StatelessWidget {
  late String itemName;
  late String price;
  late String size;
  int quantity;
  orderList(this.itemName, this.price, this.size, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          child: Text(
            '$itemName\n($size)',
            style: TextStyle(fontFamily: 'Kanit', fontStyle: FontStyle.normal),
          ),
        ),
        Text(
          'x$quantity',
          style: TextStyle(fontFamily: 'Kanit', fontStyle: FontStyle.normal),
        ),
        Text(
          '$price',
          style: TextStyle(fontFamily: 'Kanit', fontStyle: FontStyle.normal),
        ),
      ],
    );
  }
}
