import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:nescafe_flutter/Screens/customisation_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nescafe_flutter/Components/carousel.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final image = [
    Image.asset('assets/images/Property 1=Default.png'),
    Image.asset('assets/images/Property 1=Variant2.png'),
    Image.asset('assets/images/Property 1=Variant3.png'),
  ];

  int myCurrIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1C0F05),
      appBar: AppBar(
        backgroundColor: Color(0xff1C0F05),
        toolbarHeight: 75,
        elevation: 1,
        title: Hero(
          tag: 'logo',
          child: Image.asset('assets/images/logo2.png', width: 120, height: 58),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.white, size: 36),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.id);
            },
            icon: Icon(CupertinoIcons.cart, color: Colors.white, size: 38),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 5000,
                    height: 45,
                    decoration: BoxDecoration(color: Color(0xff1E130E)),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.search),
                        ),
                        hintText: 'Get your fav Nescafe cup now...',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff8D8D8D),
                        ),
                        filled: true,
                        fillColor: Color(0xffE6DCDB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 40, bottom: 4),
                        child: CarouselSlider(
                          items: image,
                          options: CarouselOptions(
                            autoPlay: true,
                            height: 200,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlayAnimationDuration: Duration(
                              milliseconds: 800,
                            ),
                            autoPlayInterval: Duration(seconds: 2),
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                myCurrIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                      AnimatedSmoothIndicator(
                        activeIndex: myCurrIndex,
                        count: image.length,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.asset('assets/images/Group 24.png'),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            bestSeller(
                              'assets/images/image.png',
                              'Caramel Coffee\nFrappe',
                            ),
                            bestSeller(
                              'assets/images/image-1.png',
                              'Loaded Cheesy\nFries',
                            ),
                            bestSeller(
                              'assets/images/image-2.png',
                              'Nescafe Gold\nIced coffee',
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            bestSeller(
                              'assets/images/image-3.png',
                              'Mix sauce\nPasta',
                            ),
                            bestSeller(
                              'assets/images/image-4.png',
                              'Paneer Makhani\nSandwich',
                            ),
                            bestSeller(
                              'assets/images/image-5.png',
                              'Peri Peri\nMaggi',
                            ),
                          ],
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 30),
                    color: Colors.white,
                    child: Text(
                      '- Menu -',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    color: Colors.white,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Carousel(
                          text: 'Coffee',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Frappe',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Fries',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Burger',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Wraps',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Mojito',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Maggie',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Krusher',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Hot Chocolate',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Sweet Corn',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Dessert',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                        Carousel(
                          text: 'Pasta',
                          colour: Color(0xff1C0F05),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  menuTitle('Coffee'),
                  Container(color: Colors.white, child: kDivider),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        menuImages('cappucino'),
                        SizedBox(height: 25),
                        menuImages('espresso'),
                        SizedBox(height: 25),
                        menuImages('black coffee'),
                        SizedBox(height: 25),
                        menuImages('americano'),
                        SizedBox(height: 25),
                        menuImages('cold coffee'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  menuTitle('Frappe'),
                  Container(color: Colors.white, child: kDivider),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        menuImages('caramel frappe'),
                        SizedBox(height: 25),
                        menuImages('Strawberry-Frappe'),
                        SizedBox(height: 25),
                        menuImages('mocha-frappe'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  menuTitle('Fries'),
                  Container(color: Colors.white, child: kDivider),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        menuImages('peri fries'),
                        SizedBox(height: 25),
                        menuImages('Loaded-Bacon-Cheese-Fries-3'),
                        SizedBox(height: 25),
                        menuImages('salted French-fries'),
                        SizedBox(height: 25),
                        menuImages('cheesy fries'),
                        SizedBox(height: 25),
                        menuImages('mint fries'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  menuTitle('Burger'),
                  Container(color: Colors.white, child: kDivider),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        menuImages('Secret-Veg-Cheeseburgers-c981dd6'),
                        SizedBox(height: 25),
                        menuImages('schezwan burger'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                  menuTitle('Wrap'),
                  Container(color: Colors.white, child: kDivider),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    color: Colors.white,
                    child: Column(
                      children: [
                        menuImages('veg wrap'),
                        SizedBox(height: 25),
                        menuImages('paneer wrap'),
                        SizedBox(height: 25),
                        menuImages('schezwan wrap'),
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class menuTitle extends StatelessWidget {
  late final String title;
  menuTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35, top: 15),
      color: Colors.white,
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
      ),
    );
  }
}

class menuImages extends StatefulWidget {
  late final String image;
  menuImages(this.image);

  @override
  State<menuImages> createState() => _menuImagesState();
}

class _menuImagesState extends State<menuImages> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CustomisationScreen.id);
      },
      child: Container(
        width: 370,
        height: 213,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu/${widget.image}.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Opacity(
              opacity: 0.75,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                ),
                width: 370,
                height: 42,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class bestSeller extends StatelessWidget {
  late final String text;
  late final String image;
  bestSeller(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(200),
          ),
          child: GestureDetector(
            child: Image.asset(image, width: 99, height: 99, fit: BoxFit.cover),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Kanit',
            fontStyle: FontStyle.normal,
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
