import 'package:flutter/material.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';

class CartScreen extends StatelessWidget {
  static const String id = 'cart_screen';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite_border_outlined,
              color: Color(0xff7C6565),
              size: 38,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50),
                  width: 435,
                  height: 469,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [cartWidget(), cartWidget(), cartWidget()],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25, left: 45, right: 45),
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
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Divider(color: Colors.black, height: 10, thickness: 0.5),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        orderList('Mix Sauce Pasta', 'Rs 110'),
                        orderList('Caramel Coffe Frappe (Regular)', 'Rs 65'),
                        orderList('Mix Sauce Pasta', 'Rs 110'),
                        orderList('Caramel Coffe Frappe (Regular)', 'Rs 65'),
                        orderList('Mix Sauce Pasta', 'Rs 110'),
                        orderList('Caramel Coffe Frappe (Regular)', 'Rs 65'),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, left: 45, right: 45),
                  color: Colors.white,
                  width: 353,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.black, height: 10, thickness: 2),
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
                          width: screenHeight < 900 ? 118 : 155,
                          child: Text(
                            'Rs 525',
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
  orderList(this.itemName, this.price);

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
                  itemName,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              Container(
                width: screenHeight < 900 ? 118 : 155,
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

class cartWidget extends StatelessWidget {
  const cartWidget({super.key});

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
                    image: AssetImage('assets/images/menu/caramel frappe.jpg'),
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
                      'Caramel Coffee Frappe',
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
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.only(left: 5),
                            width: 76,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: Color(0xffD9D9D9),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Regular',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Kanit',
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down),
                              ],
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
                          Icon(Icons.remove),
                          Text('1', style: TextStyle(fontSize: 18)),
                          Icon(Icons.add),
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
