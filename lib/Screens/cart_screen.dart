import 'dart:async';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:nescafe_flutter/Screens/order_confirmation_screen.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:nescafe_flutter/order_api.dart';

bool switchValue = false;

late String currentFirestoreOrderId;

class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  String customerName = '';
  String customerPhone = '';
  void showCustomerDetailsPopup(BuildContext outerContext) {
    showDialog(
      context: outerContext,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Enter Your Details',
            style: TextStyle(
              color: Color(0xff7C6565),
              fontFamily: 'Kanit',
              fontStyle: FontStyle.normal,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  style: TextStyle(color: Color(0xff7C6565)),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Color(0xff7C6565),
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff7C6565)),
                    ),
                  ),
                  onChanged: (value) => customerName = value.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  style: TextStyle(color: Color(0xff7C6565)),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(
                      color: Color(0xff7C6565),
                      fontFamily: 'Kanit',
                      fontStyle: FontStyle.normal,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff7C6565)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) => customerPhone = value.trim(),
                  validator: (value) {
                    if (value == null ||
                        value.trim().length != 10 ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xff7C6565),
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff7C6565),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);

                  // Show loader
                  showDialog(
                    context: outerContext,
                    barrierDismissible: false,
                    builder:
                        (context) => Center(child: CircularProgressIndicator()),
                  );

                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // ✅ Save customer data to 'customers' collection for future use
                    await FirebaseFirestore.instance
                        .collection('customers')
                        .doc(user.uid)
                        .set({
                          'name': customerName,
                          'phone': customerPhone,
                          'email': user.email,
                          'uid': user.uid,
                        });
                  }

                  String? orderId = await saveOrderToFirestore();

                  Navigator.pop(outerContext); // Close loader

                  if (orderId != null) {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderId)
                        .update({
                          'customer_name': customerName,
                          'customer_phone': customerPhone,
                        });

                    showOrderStatusPopup(outerContext, orderId);
                  } else {
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to place order',
                          style: TextStyle(color: Color(0xff7C6565)),
                        ),
                        backgroundColor: Colors.white,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Kanit',
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  late Razorpay _razorpay;
  Timer? _dialogTimer;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _dialogTimer?.cancel();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final paymentId = response.paymentId;

    if (currentFirestoreOrderId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(currentFirestoreOrderId)
          .update({
            'payment_status': 'successful',
            'payment_id': paymentId,
            'status': 'accepted',
          });

      // Navigate to confirmation screen
      if (context.mounted) {
        Navigator.of(context).pop(); // close the dialog first
        Future.delayed(Duration(milliseconds: 300), () {
          if (context.mounted) {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(seconds: 2),
                pageBuilder:
                    (_, __, ___) => OrderConfirmationScreen(
                      orderId: currentFirestoreOrderId,
                    ),
              ),
            );
          }
        });
      }
    } else {
      debugPrint("Order ID not found!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet selected: ${response.walletName}");
  }

  void showPaymentTimerDialog(
    BuildContext parentContext,
    String orderId,
    double amount,
  ) {
    final endTime = DateTime.now().add(Duration(minutes: 2));
    bool isTimeUp = false;

    final orderRef = FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId);
    orderRef.update({'payment_status': 'N/A'});

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            _dialogTimer?.cancel();
            _dialogTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
              final now = DateTime.now();
              final difference = endTime.difference(now);

              if (difference.isNegative && !isTimeUp) {
                timer.cancel();
                isTimeUp = true;

                await orderRef.update({
                  'payment_status': 'cancelled',
                  'status': 'declined',
                });

                if (context.mounted) setState(() {});
              } else {
                if (context.mounted) setState(() {});
              }
            });

            return WillPopScope(
              onWillPop: () async => false,
              child: Builder(
                builder: (context) {
                  final now = DateTime.now();
                  final remaining = endTime.difference(now);
                  final minutes = remaining.inMinutes
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');
                  final seconds = remaining.inSeconds
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');

                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      isTimeUp ? 'Payment Failed' : 'Payment Processing',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        color: isTimeUp ? Colors.red : Colors.black,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isTimeUp) ...[
                          Text(
                            'Please complete your payment within:',
                            style: TextStyle(fontFamily: 'Kanit'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '$minutes:$seconds',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          SizedBox(height: 16),
                          RoundedButton(
                            text: 'Pay Now',
                            colour: Color(0xff7C6565),
                            textColour: Colors.white,
                            onPressed: () async {
                              final orderRef = FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderId);
                              orderRef.update({'payment_status': 'pending'});
                              currentFirestoreOrderId = orderId;
                              int totalAmount = (amount * 100).toInt();

                              final id = await OrderAPI.generateOrderID(
                                totalAmount,
                              );
                              print('The order id is $id');

                              try {
                                var options = {
                                  'key': 'rzp_live_CMd1pX2dby3B2x',
                                  'amount': totalAmount,
                                  'name':
                                      customerName.isNotEmpty
                                          ? customerName
                                          : 'Customer',
                                  'description': 'Your Order',
                                  'order_id': id,
                                  'prefill': {
                                    'contact':
                                        customerPhone.isNotEmpty
                                            ? customerPhone
                                            : '9999999999',
                                    'email':
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.email ??
                                        'test@example.com',
                                  },
                                  'notes': {
                                    'orderId': orderId,
                                    'id': id,
                                    'userId':
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.uid ??
                                        '',
                                  },
                                };

                                _razorpay.open(options);
                              } catch (e) {
                                debugPrint('Razorpay Error: $e');
                              }
                            },
                          ),
                        ] else ...[
                          Text(
                            'Oops! Your payment was not completed in time.',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              Future.delayed(Duration(milliseconds: 300), () {
                                if (parentContext.mounted) {
                                  Navigator.pushReplacement(
                                    parentContext,
                                    MaterialPageRoute(
                                      builder: (_) => CartScreen(),
                                    ),
                                  );
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    ).then((_) => _dialogTimer?.cancel());
  }

  void showOrderStatusPopup(BuildContext context, String orderId) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    double totalAmount = cartProvider.getTotalPrice();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(orderId)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return AlertDialog(
                title: Text('Placing Order'),
                backgroundColor: Colors.white,
                content: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;
            final status = data['status'];

            if (status == 'accepted') {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Order Accepted!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7C6565),
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                content: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your order has been accepted. \nSwipe to confirm your order.',
                        style: TextStyle(
                          color: Color(0xff7C6565),
                          fontFamily: 'Kanit',
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          child: IconTheme.merge(
                            data: IconThemeData(color: Colors.white),
                            child: AnimatedToggleSwitch.dual(
                              current: switchValue,
                              first: false,
                              second: true,
                              spacing: 80,
                              animationDuration: Duration(milliseconds: 600),
                              style: const ToggleStyle(
                                borderColor: Colors.transparent,
                                indicatorColor: Color(0xff1C0F05),
                                backgroundColor: Color(0xffD9D9D9),
                              ),
                              borderWidth: 8,
                              height: 50,
                              customStyleBuilder: (context, local, global) {
                                if (global.position <= 0) {
                                  return ToggleStyle(
                                    backgroundColor: Color(0xff7C6565),
                                  );
                                }
                                return ToggleStyle(
                                  backgroundGradient: LinearGradient(
                                    colors: [
                                      Color(0xffD9D9D9),
                                      Color(0xff7C6565)!,
                                    ],
                                    stops: [
                                      global.position -
                                          (1 -
                                                  2 *
                                                      max(
                                                        0,
                                                        global.position - 0.5,
                                                      )) *
                                              0.7,
                                      global.position +
                                          max(0, 2 * (global.position - 0.5)) *
                                              0.7,
                                    ],
                                  ),
                                );
                              },
                              loadingIconBuilder:
                                  (context, global) =>
                                      CupertinoActivityIndicator(
                                        color: Color.lerp(
                                          Color(0xffD9D9D9),
                                          Color(0xff7C6565),
                                          global.position,
                                        ),
                                      ),
                              onChanged: (value) async {
                                setState(() {
                                  switchValue = value;
                                });

                                if (value == true) {
                                  Navigator.of(context).pop(); // Close dialog

                                  Future.delayed(Duration(milliseconds: 300));
                                  showPaymentTimerDialog(
                                    context,
                                    orderId,
                                    totalAmount,
                                  );

                                  setState(() {
                                    switchValue = false;
                                  });
                                }
                              },
                              iconBuilder:
                                  (value) =>
                                      value
                                          ? Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: Colors.white,
                                          )
                                          : Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                          ),
                              textBuilder:
                                  (value) =>
                                      value
                                          ? Text('REDIRECTING')
                                          : Text('CONFIRM TO PAY'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (status == 'declined') {
              final reason = data['owner_reason'] ?? 'No reason provided.';
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Order Rejected',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7C6565),
                    fontFamily: 'Kanit',
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sorry, the owner has rejected your order.',
                      style: TextStyle(
                        color: Color(0xff7C6565),
                        fontFamily: 'Kanit',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Reason:\n$reason',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Color(0xff7C6565),
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Waiting for store...',
                  style: TextStyle(
                    color: Color(0xff7C6565),
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xff7C6565)),
                    SizedBox(height: 16),
                    Text(
                      'Waiting for your store to accept the order...',
                      style: TextStyle(
                        color: Color(0xff7C6565),
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  // showPaymentTimerDialog(context);
  // Navigator.push(
  //   context,
  //   PageRouteBuilder(
  //     transitionDuration: Duration(seconds: 2),
  //     pageBuilder:
  //         (_, __, ___) =>
  //             OrderConfirmationScreen(
  //               orderId: orderId,
  //             ),
  //   ),
  // );
  Future<String?> saveOrderToFirestore() async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    var cartItems = cartProvider.cart;
    var cartDuplicateItems = cartProvider.cartDuplicate;

    // Get current user ID from Firebase Auth
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Order items array
    List<Map<String, dynamic>> orderItems = [];

    // Loop through regular cart items
    for (var item in cartItems) {
      orderItems.add({
        'name': item.name,
        'size': 'Regular', // For items without size
        'quantity': item.quantity,
        'price': item.price,
        'total_price': item.price * item.quantity,
        'image': item.image,
      });
    }

    // Loop through duplicate items
    for (var item in cartDuplicateItems) {
      orderItems.add({
        'name': item.name,
        'size': item.size, // For items with size
        'quantity': item.quantity,
        'price': item.price,
        'total_price': item.price * item.quantity,
        'image': item.image,
      });
    }

    // Calculate total price of the order
    double totalPrice = cartProvider.getTotalPrice();

    // Get current date
    DateTime now = DateTime.now();

    // Create order document in Firestore
    try {
      DocumentReference orderRef = await FirebaseFirestore.instance
          .collection('orders')
          .add({
            'user_id': userId,
            'order_items': orderItems,
            'status': null,
            'order_date': now,
            'order_number':
                'ORD-${now.millisecondsSinceEpoch}', // Unique order number
            'total_price': totalPrice,
          });

      print("Order placed successfully: ${orderRef.id}");
      return orderRef.id;
    } catch (e) {
      print('Error placing order: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.cart; // Items without size
    var cartDuplicateItems = cartProvider.cartDuplicate;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isCartEmpty = cartItems.isEmpty && cartDuplicateItems.isEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Cart',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontStyle: FontStyle.normal,
            color: Colors.black,
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
            color: Color(0xff7C6565),
            size: 45,
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 75,
      ),
      backgroundColor: Colors.white,
      body:
          isCartEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Your Cart seems Hungry like You",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(top: 5, left: 95, right: 95),
                    color: Colors.white,
                    child: RoundedButton(
                      text: 'GO TO MENU',
                      colour: Colors.white,
                      textColour: Color(0xff7C6565),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 50),
                          width: 435,
                          height: 469,
                          child: ListView.builder(
                            itemCount:
                                context.watch<CartProvider>().cart.length +
                                context
                                    .watch<CartProvider>()
                                    .cartDuplicate
                                    .length,
                            itemBuilder: (context, index) {
                              final cartProvider =
                                  context.watch<CartProvider>();

                              // Cart List + CartDuplicate List ko merge karke correct index fetch karna
                              bool isDuplicateItem =
                                  index >= cartProvider.cart.length;
                              if (isDuplicateItem) {
                                final duplicateItem =
                                    cartProvider.cartDuplicate[index -
                                        cartProvider.cart.length];

                                return cartWidget(
                                  duplicateItem.image,
                                  duplicateItem.name,
                                  duplicateItem.size,
                                  duplicateItem.quantity,
                                );
                              } else {
                                final item = cartProvider.cart[index];

                                return cartWidgetDuplicate(
                                  item.name,
                                  item.image,
                                  item.quantity,
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 25,
                            left: 45,
                            right: 45,
                          ),
                          color: Colors.white,
                          width: 353,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Meal For You Is Awaiting...',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                height: 10,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 55,
                            left: 55,
                          ),
                          height: 130,
                          child: ListView.builder(
                            itemCount:
                                context.watch<CartProvider>().cart.length +
                                context
                                    .watch<CartProvider>()
                                    .cartDuplicate
                                    .length,
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
                                    cartDuplicateItems[index -
                                        cartItems.length];
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
                        Container(
                          padding: EdgeInsets.only(top: 5, left: 45, right: 45),
                          color: Colors.white,
                          width: 353,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(
                                color: Colors.black,
                                height: 10,
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                            right: 55,
                            left: 55,
                          ),
                          child: Container(
                            width: 329,
                            child: Row(
                              children: [
                                Container(
                                  width: 164.5,
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: screenHeight < 900 ? 118 : 145,
                                  child: Text(
                                    'Rs ${context.watch<CartProvider>().getTotalPrice().toStringAsFixed(2)}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5, left: 95, right: 95),
                          color: Colors.white,
                          child: RoundedButton(
                            text: 'Proceed',
                            colour: Colors.white,
                            textColour: Color(0xff7C6565),
                            onPressed: () async {
                              final selectedLocation =
                                  Provider.of<LocationProvider>(
                                    context,
                                    listen: false,
                                  ).selectedLocation;

                              if (selectedLocation == null) {
                                // ⚠️ Show warning dialog
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text(
                                          "Location Required",
                                          style: TextStyle(
                                            color: Color(0xff7C6565),
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                        content: Text(
                                          "Please select your location before placing the order.",
                                          style: TextStyle(
                                            color: Color(0xff7C6565),
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                color: Color(0xff7C6565),
                                                fontFamily: 'Kanit',
                                              ),
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                );
                                return;
                              }

                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                DocumentSnapshot customerDoc =
                                    await FirebaseFirestore.instance
                                        .collection('customers') // or 'users'
                                        .doc(user.uid)
                                        .get();

                                if (customerDoc.exists) {
                                  // ✅ Already saved - fetch and use the details directly
                                  final data =
                                      customerDoc.data()
                                          as Map<String, dynamic>;
                                  customerName = data['name'];
                                  customerPhone = data['phone'];

                                  // Place order directly
                                  String? orderId =
                                      await saveOrderToFirestore();
                                  if (orderId != null) {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(orderId)
                                        .update({
                                          'customer_name': customerName,
                                          'customer_phone': customerPhone,
                                          'location':
                                              selectedLocation, // ✅ Save location
                                        });

                                    showOrderStatusPopup(context, orderId);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to place order',
                                          style: TextStyle(
                                            color: Color(0xff7C6565),
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                      ),
                                    );
                                  }
                                } else {
                                  // ❌ Not saved yet - show popup
                                  showCustomerDetailsPopup(context);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: 329,
          child: Row(
            children: [
              Container(
                width: 164.5,
                child: Text(
                  '$itemName\n($size) x$quantity',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Container(
                width: screenHeight < 900 ? 118 : 145,
                child: Text(
                  price,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.6,
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class cartWidgetDuplicate extends StatefulWidget {
  String name;
  String image;
  int quantity;
  cartWidgetDuplicate(this.name, this.image, this.quantity);

  @override
  State<cartWidgetDuplicate> createState() => _cartWidgetDuplicateState();
}

class _cartWidgetDuplicateState extends State<cartWidgetDuplicate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 35),
          width: 363,
          height: 188,
          decoration: BoxDecoration(
            color: Color(0xff7C6565),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://drive.google.com/uc?export=view&id=${widget.image}',
                      width: 134,
                      height: 134,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Image.asset(
                            'assets/images/menu/buffering_img.jpg',
                            fit: BoxFit.cover,
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 134,
                            height: 134,
                            color: Colors.white,
                            child: Icon(Icons.error),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),
              Container(
                width: 160,
                height: 134,
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Size:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.only(left: 14, top: 3.5),
                          width: 76,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: Color(0xffD9D9D9),
                          ),
                          child: Text(
                            'Regular',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Kanit',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 132,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        color: Color(0xffD9D9D9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.remove),
                            onTap: () {
                              setState(() {
                                if (widget.quantity > 0) {
                                  widget.quantity--;
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).removeFromCart(
                                    name: widget.name,
                                    size: null,
                                  );
                                }
                              });
                            },
                          ),
                          Text(
                            '${widget.quantity}',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Icon(Icons.add),
                            onTap: () {
                              setState(() {
                                widget.quantity++;
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).repeatOrder(name: widget.name, size: null);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class cartWidget extends StatefulWidget {
  String image;
  String selectedSize;
  int quantity;
  String name;
  cartWidget(this.image, this.name, this.selectedSize, this.quantity);

  @override
  State<cartWidget> createState() => _cartWidgetState();
}

class _cartWidgetState extends State<cartWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 35),
          width: 363,
          height: 188,
          decoration: BoxDecoration(
            color: Color(0xff7C6565),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://drive.google.com/uc?export=view&id=${widget.image}',
                      width: 134,
                      height: 134,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Image.asset(
                            'assets/images/menu/buffering_img.jpg',
                            fit: BoxFit.cover,
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 134,
                            height: 134,
                            color: Colors.white,
                            child: Icon(Icons.error),
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15),
              Container(
                width: 160,
                height: 134,
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Size:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          padding: EdgeInsets.only(left: 14, top: 3.5),
                          width: 76,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: Color(0xffD9D9D9),
                          ),
                          child: Text(
                            '${widget.selectedSize}',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Kanit',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: 132,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        color: Color(0xffD9D9D9),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.remove),
                            onTap: () {
                              setState(() {
                                if (widget.quantity > 0) {
                                  widget.quantity--;
                                  Provider.of<CartProvider>(
                                    context,
                                    listen: false,
                                  ).removeFromCart(
                                    name: widget.name,
                                    size: widget.selectedSize,
                                  );
                                }
                              });
                            },
                          ),
                          Text(
                            '${widget.quantity}',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Icon(Icons.add),
                            onTap: () {
                              setState(() {
                                widget.quantity++;
                                Provider.of<CartProvider>(
                                  context,
                                  listen: false,
                                ).repeatOrder(
                                  name: widget.name,
                                  size: widget.selectedSize,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
