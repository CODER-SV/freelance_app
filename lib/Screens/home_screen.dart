import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:nescafe_flutter/Components/carousel.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Components/sections.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

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
  final sectionKeys = GlobalKey();

  int myCurrIndex = 0;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  // Scroll to a specific section
  Future scrollToItem(int index) async {}

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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sections.length,
                    itemBuilder: (context, index) {
                      return Carousel(
                        text: sections[index]['name'],
                        colour: const Color(0xff1C0F05),
                        isSelected: selectedSection == sections[index]['name'],
                        onPressed: () {
                          setState(() {
                            selectedSection = sections[index]['name'];
                          });
                          scrollToItem(index);
                        },
                      );
                    },
                  ),
                ),
                ...List.generate(sections.length, (index) {
                  return Column(
                    children: [
                      menuTitle(sections[index]['name']),
                      if (sections[index]['images'].isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          width: 500,
                          color: Colors.white,
                          child: Column(
                            children: List.generate(
                              sections[index]['images'].length,
                              (i) {
                                return sections[index]['useDuplicate'][i] ==
                                        true
                                    ? menuImagesDuplicate(
                                      sections[index]['images'][i],
                                      sections[index]['item'][i],
                                      sections[index]['price'][i],
                                      sections[index]['priceRegular'][i], // ✅ Pass Regular Price
                                      sections[index]['priceLarge'][i], // ✅ Pass Large Price
                                    )
                                    : menuImages(
                                      sections[index]['images'][i],
                                      sections[index]['item'][i],
                                      sections[index]['price'][i],
                                    );
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                }),
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
                  offset: Offset(-160, -280), // Position above FAB
                  child: SlideTransition(
                    position: _animation,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 300, // Adjust height based on content
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Menu Sections",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(thickness: 1),

                            // Scrollable List of Sections
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: sections.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      sections[index]['name'],
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    leading: Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.brown,
                                    ),
                                    onTap: () {
                                      print(
                                        "${sections[index]['name']} Selected",
                                      );
                                      _toggleMenu(); // Close on selection
                                    },
                                  );
                                },
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
  final Function(String, int) onSizeSelected; // Callback function

  popUpCustomize(this.regularPrice, this.largePrice, this.onSizeSelected);

  @override
  State<popUpCustomize> createState() => _popUpCustomizeState();
}

class _popUpCustomizeState extends State<popUpCustomize> {
  String? selectedSize; // To store selected option

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
                      selectedSize = value! ? 'Regular' : null;
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
                      selectedSize = value! ? 'Large' : null;
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
                  text: 'Back',
                  colour: Color(0xff7C6565),
                  textColour: Colors.white,
                  onPressed: () {
                    int selectedPrice =
                        selectedSize == 'Regular'
                            ? widget.regularPrice
                            : widget.largePrice;
                    widget.onSizeSelected(
                      selectedSize!,
                      selectedPrice,
                    ); // ✅ Pass data back
                    Navigator.pop(context);
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffF9D7D7),
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add'),
                          SizedBox(width: 5),
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
  late int _selectedPrice; // Dynamic price

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
                child: popUpCustomize(widget.regularPrice, widget.largePrice, (
                  String selectedSize,
                  int selectedPrice,
                ) {
                  // Callback function
                  setState(() {
                    _selectedSize = selectedSize;
                    _selectedPrice = selectedPrice;
                  });
                }),
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
    return Column(
      children: [
        Container(
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
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xffF9D7D7),
                        borderRadius: BorderRadius.all(Radius.circular(21)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Add'),
                          SizedBox(width: 5),
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
