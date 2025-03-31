import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                      onPressed: () {
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
                            onPressed: () {},
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
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Container(
                width: screenHeight < 900 ? 118 : 145,
                child: Text(
                  price,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.black, fontSize: 15.6),
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
              Container(
                width: 134,
                height: 134,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://drive.google.com/uc?export=view&id=${widget.image}',
                    ),
                    fit: BoxFit.cover,
                  ),
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
                          'Select Size:',
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
                                    name: widget.name, // pass the item name
                                    size:
                                        null, // pass size if needed, or pass null
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
              Container(
                width: 134,
                height: 134,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://drive.google.com/uc?export=view&id=${widget.image}',
                    ),
                    fit: BoxFit.cover,
                  ),
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
                          'Select Size:',
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
                                    name: widget.name, // pass the item name
                                    size:
                                        widget
                                            .selectedSize, // pass size if needed, or pass null
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
