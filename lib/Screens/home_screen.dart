import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../provider/cart_provider.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
final ItemScrollController _scrollController = ItemScrollController();

void scrollToSection(int index) {
  _scrollController.scrollTo(
    index: index,
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
}

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

  String selectedSection = ''; // Default selected section

  int myCurrIndex = 0;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //retrieveAll();
  }

  // void retrieveAll() {
  //   _firestore
  //       .collection('sections')
  //       .get()
  //       .then(
  //         (value) => {
  //           value.docs.forEach((result) {
  //             print(result.id);
  //             _firestore
  //                 .collection('sections')
  //                 .doc(result.id)
  //                 .collection('item')
  //                 .get()
  //                 .then(
  //                   (subCol) => {
  //                     subCol.docs.forEach((elements) {
  //                       print(elements.id);
  //                       print(elements.data());
  //                     }),
  //                   },
  //                 );
  //           }),
  //         },
  //       );
  // }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void openDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Dismiss when tapping outside
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300), // Adjust speed
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: kToolbarHeight,
              left: 10, // Starting position
              child: Material(color: Colors.transparent, child: popUp()),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, 0), // Start from left (off-screen)
            end: Offset(0, 0), // Move to its position
          ).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutExpo, // Smooth pull-in
              reverseCurve: Curves.easeInExpo, // Smooth pull-out
            ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingMenuButton(),
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
          onPressed: () {
            setState(() {
              openDialog(context);
            });
          },
          icon: Icon(Icons.menu, color: Colors.white, size: 36),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return ValueListenableBuilder<int>(
                valueListenable: cartProvider.cartItemCount, // 🟢 Updated count
                builder: (context, value, child) {
                  return IconButton(
                    icon: Stack(
                      children: [
                        Icon(
                          value > 0
                              ? CupertinoIcons.cart_fill
                              : CupertinoIcons.cart,
                          color: Colors.white,
                          size: 38,
                        ),
                        if (value > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$value',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
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
                StreamBuilder(
                  stream: _firestore.collection('sections').snapshots(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return Container(
                      height: 650,
                      child: ScrollablePositionedList.builder(
                        itemScrollController: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var sectionDoc = snapshot.data!.docs[index];

                          return Column(
                            children: [
                              menuTitle(sectionDoc.id),
                              StreamBuilder(
                                stream:
                                    _firestore
                                        .collection('sections')
                                        .doc(sectionDoc.id)
                                        .collection('item')
                                        .snapshots(),
                                builder: (
                                  context,
                                  AsyncSnapshot<QuerySnapshot> itemSnapshot,
                                ) {
                                  if (!itemSnapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  if (itemSnapshot.data!.docs.isEmpty) {
                                    return SizedBox.shrink(); // Agar koi item nahi hai toh empty
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 25,
                                    ),
                                    width: 500,
                                    color: Colors.white,
                                    child: Column(
                                      children: List.generate(
                                        itemSnapshot.data!.docs.length,
                                        (i) {
                                          var itemDoc =
                                              itemSnapshot.data!.docs[i];
                                          var itemData =
                                              itemDoc.data()
                                                  as Map<String, dynamic>;

                                          return (itemData['useDuplicate'] ==
                                                  true)
                                              ? menuImagesDuplicate(
                                                itemData['images'] ?? "",
                                                itemDoc
                                                    .id, // 🔥 Item name from Document ID
                                                int.tryParse(
                                                      itemData['price']
                                                          .toString(),
                                                    ) ??
                                                    0, // 🔥 Convert String to Int
                                                int.tryParse(
                                                      itemData['priceRegular']
                                                          .toString(),
                                                    ) ??
                                                    0,
                                                int.tryParse(
                                                      itemData['priceLarge']
                                                          .toString(),
                                                    ) ??
                                                    0,
                                              )
                                              : menuImages(
                                                itemData['images'] ?? "",
                                                itemDoc
                                                    .id, // 🔥 Item name from Document ID
                                                int.tryParse(
                                                      itemData['price']
                                                          .toString(),
                                                    ) ??
                                                    0,
                                              );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingMenuButton extends StatefulWidget {
  @override
  _FloatingMenuButtonState createState() => _FloatingMenuButtonState();
}

class _FloatingMenuButtonState extends State<FloatingMenuButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Animation speed
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 1), // Start below the FAB
      end: Offset(0, 0), // Move to position
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo, // Smooth pull-in
        reverseCurve: Curves.easeInExpo, // Smooth pull-out
      ),
    );
  }

  void _toggleMenu() {
    if (_overlayEntry == null) {
      _overlayEntry = _createFloatingDialog();
      Overlay.of(context).insert(_overlayEntry!);
      _animationController.forward();
    } else {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  OverlayEntry _createFloatingDialog() {
    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Tap outside to close dialog
              GestureDetector(
                onTap: _toggleMenu,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.transparent, // Invisible tap area
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),

              // Positioned Floating Dialog
              Positioned(
                width: 230,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  offset: Offset(-160, -250), // Position above FAB
                  child: SlideTransition(
                    position: _animation,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 8,
                        ),
                        height: 250, // Reduced height to make it compact
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Title with Less Padding
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 5,
                              ), // Less gap
                              child: Text(
                                "Menu Sections",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.5,
                              indent: 35,
                              endIndent: 35,
                            ),

                            Expanded(
                              child: SizedBox(
                                width:
                                    double
                                        .infinity, // Ensures ListView takes full width
                                height:
                                    double
                                        .infinity, // Ensures it fills remaining space
                                child: StreamBuilder(
                                  stream:
                                      _firestore
                                          .collection('sections')
                                          .snapshots(), // ✅ Fetch sections dynamically
                                  builder: (
                                    context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    var sectionDocs =
                                        snapshot
                                            .data!
                                            .docs; // ✅ List of section documents

                                    return ListView.builder(
                                      itemCount: sectionDocs.length,
                                      padding:
                                          EdgeInsets
                                              .zero, // Removes unwanted padding
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            print(
                                              "${sectionDocs[index].id} Selected",
                                            ); // ✅ Firestore se section ka naam
                                            _toggleMenu(); // Close the menu
                                            Future.delayed(
                                              Duration(milliseconds: 300),
                                              () {
                                                scrollToSection(
                                                  index,
                                                ); // Scroll after the menu closes
                                              },
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 12.0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.restaurant_menu,
                                                  color: Colors.brown,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ), // Space between icon and text
                                                Text(
                                                  sectionDocs[index]
                                                      .id, // ✅ Firestore ka section name
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FloatingActionButton(
        onPressed: _toggleMenu,
        backgroundColor: Color(0xff5F4B48),
        shape: CircleBorder(),
        child: Text(
          "Menu",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class popUpCustomize extends StatefulWidget {
  late final int regularPrice;
  late final int largePrice;
  late final String selectedSize;
  final Function(String, int) onSizeSelected; // Callback function

  popUpCustomize(
    this.regularPrice,
    this.largePrice,
    this.selectedSize,
    this.onSizeSelected,
  );

  @override
  State<popUpCustomize> createState() => _popUpCustomizeState();
}

class _popUpCustomizeState extends State<popUpCustomize> {
  String? selectedSize; // To store selected option
  @override
  void initState() {
    super.initState();
    selectedSize = widget.selectedSize; // ✅ Set initial selection
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 220,
      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9).withOpacity(0.9),
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Size',
            style: TextStyle(
              fontFamily: 'Kanit',
              color: Color(0xff7C6565),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Divider(color: Colors.black, height: 8, thickness: 0.5),

          // Regular Size Option
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Text(
                  'Regular',
                  style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
                ),
                SizedBox(width: 10),
                Checkbox(
                  value: selectedSize == 'Regular',
                  onChanged: (bool? value) {
                    setState(() {
                      if (selectedSize != 'Regular') {
                        selectedSize = 'Regular';
                      }
                    });
                  },
                ),
                SizedBox(width: 33),
                Text(
                  'Rs ${widget.regularPrice}',
                  style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
                ),
              ],
            ),
          ),

          // Large Size Option
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Text(
                  'Large',
                  style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
                ),
                SizedBox(width: 25),
                Checkbox(
                  value: selectedSize == 'Large',
                  onChanged: (bool? value) {
                    setState(() {
                      if (selectedSize != 'Large') {
                        selectedSize = 'Large';
                      }
                    });
                  },
                ),
                SizedBox(width: 33),
                Text(
                  'Rs ${widget.largePrice}',
                  style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: 60),
              SizedBox(
                width: 88,
                height: 66,
                child: RoundedButton(
                  text: 'Okay',
                  colour: Color(0xff7C6565),
                  textColour: Colors.white,
                  onPressed: () {
                    if (selectedSize != null) {
                      int selectedPrice =
                          selectedSize == 'Regular'
                              ? widget.regularPrice
                              : widget.largePrice;

                      widget.onSizeSelected(selectedSize!, selectedPrice);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class popUp extends StatelessWidget {
  const popUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_circle_left_rounded,
              color: Color(0xff5F4B48),
              size: 35,
            ),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              SizedBox(width: 20),
              Container(
                padding: EdgeInsets.only(left: 28),
                width: 262,
                height: 116,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.3,
                      ), // Shadow color with opacity
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 8, // How soft the shadow is
                      offset: Offset(4, 4), // X and Y offset (moves shadow)
                    ),
                  ],
                  color: Color(0xff5F4B48),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: Row(
                  children: [
                    Text(
                      'Welcome Guest',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xffE8DBDB),
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Transform.translate(
                      offset: Offset(0, -8),
                      child: Image.asset('assets/images/Group 31.png'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              SizedBox(width: 20),
              Icon(Icons.logout),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  _auth
                      .signOut()
                      .then((_) {
                        Navigator.pushReplacementNamed(
                          context,
                          'login_screen',
                        ); // ✅ Replace with Login Screen
                      })
                      .catchError((error) {
                        print("Logout Error: $error");
                      });
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 35, top: 15),
          width: 500,
          color: Colors.white,
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
          ),
        ),
        Container(color: Colors.white, child: kDivider),
      ],
    );
  }
}

class menuImages extends StatefulWidget {
  final String image;
  final String item;
  final int price;
  menuImages(this.image, this.item, this.price);

  @override
  State<menuImages> createState() => _menuImagesState();
}

class _menuImagesState extends State<menuImages> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // 🛒 Hamesha latest quantity Provider se lo
    int quantity = cartProvider.getQuantity(widget.item, null);
    return Column(
      children: [
        Container(
          width: 370,
          height: 213,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://drive.google.com/uc?export=view&id=${widget.image}',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(right: 45),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9).withOpacity(0.75),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                ),
                width: 370,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Kanit',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Regular - Rs ${widget.price}',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Kanit',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity == 0) {
                            quantity = 1;

                            // Cart mein item add karo
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(
                              name: widget.item, // Item ka naam
                              image: widget.image, // Item ki image URL
                              price: widget.price, // Item ka price
                            );
                          }
                        });
                      },
                      child:
                          quantity == 0
                              ? Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xffF9D7D7),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(21),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Add'),
                                    SizedBox(width: 5),
                                    Icon(Icons.add),
                                  ],
                                ),
                              )
                              : Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(0xffF9D7D7),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantity > 0) {
                                            // Call the removeFromCart method from CartProvider
                                            Provider.of<CartProvider>(
                                              context,
                                              listen: false,
                                            ).removeFromCart(
                                              name:
                                                  widget
                                                      .item, // pass the item name
                                              size:
                                                  null, // pass size if needed, or pass null
                                            );
                                            quantity--; // Decrease the quantity
                                          }
                                        });
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                    Text(
                                      '$quantity',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          quantity++;

                                          // Cart mein item add karo jab quantity increase ho
                                          Provider.of<CartProvider>(
                                            context,
                                            listen: false,
                                          ).addToCart(
                                            name: widget.item,
                                            image: widget.image,
                                            price: widget.price,
                                          );
                                        });
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

class menuImagesDuplicate extends StatefulWidget {
  final String image;
  final String item;
  final int price;
  final int regularPrice;
  final int largePrice;
  menuImagesDuplicate(
    this.image,
    this.item,
    this.price,
    this.regularPrice,
    this.largePrice,
  );

  @override
  State<menuImagesDuplicate> createState() => _menuImagesDuplicateState();
}

class _menuImagesDuplicateState extends State<menuImagesDuplicate> {
  String _selectedSize = 'Regular'; // Default selection
  late int _selectedPrice;
  int quantity = 0; // Dynamic price

  @override
  void initState() {
    super.initState();
    _selectedPrice = widget.price; // Default price is Regular
  }

  void openRightDialog(BuildContext context, TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final tapPosition = renderBox.localToGlobal(details.localPosition);

    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Close on tap outside
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300), // Animation speed
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: tapPosition.dy,
              left: 150,
              child: Material(
                color: Colors.transparent,
                child: popUpCustomize(
                  widget.regularPrice,
                  widget.largePrice,
                  _selectedSize,
                  (String selectedSize, int selectedPrice) {
                    // Callback function
                    setState(() {
                      _selectedSize = selectedSize;
                      _selectedPrice = selectedPrice;
                      var cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );
                      var existingItem = cartProvider.cartDuplicate.firstWhere(
                        (item) =>
                            item.name == widget.item &&
                            item.size == selectedSize,
                        orElse:
                            () => CartDuplicateItem(
                              name: '',
                              image: '',
                              price: 0,
                              size: '',
                              quantity: 0,
                            ),
                      );

                      // 🔹 If item exists, use its quantity; otherwise, reset to 0
                      quantity =
                          (existingItem.name.isNotEmpty)
                              ? existingItem.quantity
                              : 0; // 🎯 Quantity reset
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0),
            end: Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutExpo, // Smooth pull-in
              reverseCurve: Curves.easeInExpo, // Smooth pull-out
            ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    // 🛒 Hamesha latest quantity Provider se lo
    int quantity = cartProvider.getQuantity(widget.item, _selectedSize);
    return Column(
      children: [
        Container(
          width: 370,
          height: 213,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://drive.google.com/uc?export=view&id=${widget.image}',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Opacity(
                opacity: 0.75,
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  width: 100,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      topLeft: Radius.circular(32),
                    ),
                  ),
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      setState(() {
                        openRightDialog(context, details);
                      });
                    },
                    child: Text(
                      'Customize',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(right: 45),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9).withOpacity(0.75),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(9),
                    topLeft: Radius.circular(9),
                  ),
                ),
                width: 370,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Kanit',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$_selectedSize - Rs $_selectedPrice',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Kanit',
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity == 0) {
                            quantity = 1;
                            Provider.of<CartProvider>(
                              context,
                              listen: false,
                            ).addToCart(
                              name: widget.item,
                              image: widget.image,
                              price: _selectedPrice,
                              size: _selectedSize,
                            );
                          }
                        });
                      },
                      child:
                          quantity == 0
                              ? Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(0xffF9D7D7),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(21),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Add'),
                                    SizedBox(width: 5),
                                    Icon(Icons.add),
                                  ],
                                ),
                              )
                              : Container(
                                width: 90,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: Color(0xffF9D7D7),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (quantity > 0) {
                                            Provider.of<CartProvider>(
                                              context,
                                              listen: false,
                                            ).removeFromCart(
                                              name:
                                                  widget
                                                      .item, // pass the item name
                                              size:
                                                  _selectedSize, // pass size if needed, or pass null
                                            );
                                            quantity--;
                                          }
                                        });
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                    Text(
                                      '$quantity',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          Provider.of<CartProvider>(
                                            context,
                                            listen: false,
                                          ).addToCart(
                                            name: widget.item,
                                            image: widget.image,
                                            price: widget.price,
                                            size: _selectedSize,
                                          );
                                          quantity++;
                                        });
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),
      ],
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
