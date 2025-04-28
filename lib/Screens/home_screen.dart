import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nescafe_flutter/Components/roundedButton.dart';
import 'package:nescafe_flutter/Constants.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:nescafe_flutter/Screens/recent_order.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../provider/cart_provider.dart';
import '../provider/data_provider.dart';

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
  List<String> locationList = [];
  String? selectedLocation;

  // Fetch locations from the "owner" collection where shop_status is 'open'
  Future<void> fetchLocationsFromOwners() async {
    try {
      final snapshot = await _firestore.collection('owner').get();
      List<String> fetchedLocations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final location = data['location'];
        final shopStatus = data['shop_status'];

        if (location != null && shopStatus == 'open') {
          fetchedLocations.add(location);
        }
      }

      setState(() {
        locationList = fetchedLocations.toSet().toList(); // Remove duplicates
      });
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  List<String> allItemNames = [];
  TextEditingController searchController = TextEditingController();
  bool showSuggestions = false;
  final ItemScrollController _scrollController = ItemScrollController();
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
    fetchAllItems();
  }

  // Fetch all items from the 'sections' collection
  void fetchAllItems() async {
    final sectionSnapshot = await _firestore.collection('sections').get();
    List<String> fetchedItems = [];

    for (var sectionDoc in sectionSnapshot.docs) {
      final itemsSnapshot =
          await _firestore
              .collection('sections')
              .doc(sectionDoc.id)
              .collection('item')
              .get();

      for (var item in itemsSnapshot.docs) {
        fetchedItems.add(item.id);
      }
    }

    setState(() {
      allItemNames = fetchedItems;
    });
  }

  // Scroll to a specific section
  void scrollToSection(int index) {
    _scrollController.scrollTo(
      index: index,
      duration: Duration(milliseconds: 800), // Adjusted for smoother scrolling
      curve: Curves.easeInOut, // Smooth curve for scrolling
    );
  }

  // Get the current logged-in user
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

  // Open profile dialog to view user details
  void openProfileDialog(BuildContext context) async {
    String name = 'No data';
    String phone = 'No data';
    String email = loggedInUser.email ?? 'No Email';
    String uid = loggedInUser.uid;

    try {
      final doc = await _firestore.collection('customers').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        name = data?['name'] ?? 'No data';
        phone = data?['phone'] ?? 'No data';
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: 100,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: ProfilePopupCard(name, phone, email, uid),
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
              curve: Curves.easeOutExpo,
              reverseCurve: Curves.easeInExpo,
            ),
          ),
          child: child,
        );
      },
    );
  }

  // Open custom dialog for menu items
  void openDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            Positioned(
              top: kToolbarHeight,
              left: 10,
              child: Material(color: Colors.transparent, child: popUp()),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, 0),
            end: Offset(0, 0),
          ).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutExpo,
              reverseCurve: Curves.easeInExpo,
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
      floatingActionButton: FloatingMenuButton(
        onSectionSelected: scrollToSection,
      ),
      backgroundColor: Color(0xff1C0F05),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff1C0F05),
          toolbarHeight: 75,
          elevation: 1,
          title: Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/images/logo2.png',
              width: 120,
              height: 58,
            ),
          ),
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        openDialog(context);
                      });
                    },
                    icon: Icon(Icons.menu, color: Colors.white, size: 36),
                  ),
                  IconButton(
                    onPressed: () async {
                      await fetchLocationsFromOwners();
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.brown[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (BuildContext context) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Select Location",
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                locationList.isEmpty
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Text(
                                        "All stores are offline right now.",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Kanit',
                                        ),
                                      ),
                                    )
                                    : SizedBox(height: 10),
                                ...locationList.map(
                                  (loc) => ListTile(
                                    title: Text(
                                      loc,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Kanit',
                                      ),
                                    ),
                                    trailing:
                                        Provider.of<LocationProvider>(
                                                  context,
                                                ).selectedLocation ==
                                                loc
                                            ? Icon(
                                              Icons.check,
                                              color: Colors.greenAccent,
                                            )
                                            : null,
                                    onTap: () {
                                      setState(() {
                                        selectedLocation = loc;
                                      });
                                      Provider.of<LocationProvider>(
                                        context,
                                        listen: false,
                                      ).setLocation(loc);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      selectedLocation == null
                          ? Icons.location_on_outlined
                          : Icons.location_on,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => openProfileDialog(context),
              icon: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
                size: 38,
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return ValueListenableBuilder<int>(
                  valueListenable: cartProvider.cartItemCount,
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
                                  color: Color(0xff7C6565),
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
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, _) {
          final sections = dataProvider.sectionsWithItems;

          if (dataProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemCount: sections.length + 6,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(height: 20);
                    } else if (index == 1) {
                      return Container(); // Placeholder for future section
                    } else if (index == 2) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 40, bottom: 4),
                            child: CarouselSlider(
                              items: image,
                              options: CarouselOptions(
                                autoPlay: true,
                                height: 200,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                autoPlayAnimationDuration: const Duration(
                                  milliseconds: 800,
                                ),
                                autoPlayInterval: const Duration(seconds: 2),
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                                onPageChanged: (i, reason) {
                                  setState(() {
                                    myCurrIndex = i;
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
                      );
                    } else if (index == 3) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Image.asset('assets/images/Group 24.png'),
                          const SizedBox(height: 25),
                        ],
                      );
                    } else if (index == 4) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BestSeller(
                                  'assets/images/image.png',
                                  'Caramel Coffee\nFrappe',
                                ),
                                BestSeller(
                                  'assets/images/image-1.png',
                                  'Loaded Cheesy\nFries',
                                ),
                                BestSeller(
                                  'assets/images/image-2.png',
                                  'Nescafe Gold\nIced coffee',
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BestSeller(
                                  'assets/images/image-3.png',
                                  'Mix sauce\nPasta',
                                ),
                                BestSeller(
                                  'assets/images/image-4.png',
                                  'Paneer Makhani\nSandwich',
                                ),
                                BestSeller(
                                  'assets/images/image-5.png',
                                  'Peri Peri\nMaggi',
                                ),
                              ],
                            ),
                            const SizedBox(height: 65),
                          ],
                        ),
                      );
                    } else if (index == 5) {
                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 35),
                        color: Colors.white,
                        child: const Text(
                          '- Menu -',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                            fontSize: 26,
                          ),
                        ),
                      );
                    }

                    final sectionIndex = index - 6;
                    final section = sections[sectionIndex];

                    return Column(
                      children: [
                        menuTitle(section['sectionId']),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          width: 500,
                          color: Colors.white,
                          child: Column(
                            children: List.generate(section['items'].length, (
                              i,
                            ) {
                              var item = section['items'][i];
                              return item['useDuplicate'] == true
                                  ? menuImagesDuplicate(
                                    item['images'] ?? "",
                                    item['id'],
                                    int.tryParse(item['price'].toString()) ?? 0,
                                    int.tryParse(
                                          item['priceRegular'].toString(),
                                        ) ??
                                        0,
                                    int.tryParse(
                                          item['priceLarge'].toString(),
                                        ) ??
                                        0,
                                  )
                                  : menuImages(
                                    item['images'] ?? "",
                                    item['id'],
                                    int.tryParse(item['price'].toString()) ?? 0,
                                  );
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FloatingMenuButton extends StatefulWidget {
  final void Function(int) onSectionSelected;

  const FloatingMenuButton({Key? key, required this.onSectionSelected})
    : super(key: key);

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
      duration: Duration(milliseconds: 300), // Smooth animation
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 1), // Start from below
      end: Offset(0, 0), // Move to center
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutExpo, // Smooth easing for pull-in effect
        reverseCurve: Curves.easeInExpo, // Smooth easing for pull-out effect
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
                        height: 250, // Adjust height for compact size
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
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
                                width: double.infinity,
                                height: double.infinity,
                                child: StreamBuilder(
                                  stream:
                                      _firestore
                                          .collection('sections')
                                          .snapshots(),
                                  builder: (
                                    context,
                                    AsyncSnapshot<QuerySnapshot> snapshot,
                                  ) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    var sectionDocs = snapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: sectionDocs.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            _toggleMenu(); // Close the menu
                                            Future.delayed(
                                              Duration(milliseconds: 300),
                                              () {
                                                widget.onSectionSelected(
                                                  index + 6,
                                                );
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
                                                SizedBox(width: 10),
                                                Text(
                                                  sectionDocs[index].id,
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

// PopUp Customize with Animation
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
                  activeColor: Color(0xff7C6565),
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
                  activeColor: Color(0xff7C6565),
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
                  onPressed: () async {
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(4, 4),
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
              Icon(Icons.watch_later_outlined),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RecentOrder.id);
                },
                child: Text(
                  'Recent Orders',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
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
                        Navigator.pushReplacementNamed(context, 'login_screen');
                      })
                      .catchError((error) {
                        print("Logout Error: $error");
                      });
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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

    int quantity = cartProvider.getQuantity(widget.item, null);

    return Column(
      children: [
        Container(
          width: 370,
          height: 213,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://drive.google.com/uc?export=view&id=${widget.image}',
                  fit: BoxFit.cover,
                  width: 370,
                  height: 213,
                  placeholder:
                      (context, url) => Image.asset(
                        'assets/images/menu/buffering_img.jpg',
                        fit: BoxFit.cover,
                      ),
                  errorWidget:
                      (context, url, error) => Center(child: Icon(Icons.error)),
                ),
                Column(
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (quantity == 0) {
                                  quantity = 1;
                                  cartProvider.addToCart(
                                    name: widget.item,
                                    image: widget.image,
                                    price: widget.price,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  cartProvider.removeFromCart(
                                                    name: widget.item,
                                                    size: null,
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
                                                cartProvider.addToCart(
                                                  name: widget.item,
                                                  image: widget.image,
                                                  price: widget.price,
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
              ],
            ),
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
    int quantity = cartProvider.getQuantity(widget.item, _selectedSize);

    return Column(
      children: [
        Container(
          width: 370,
          height: 213,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://drive.google.com/uc?export=view&id=${widget.image}',
                  fit: BoxFit.cover,
                  width: 370,
                  height: 213,
                  placeholder:
                      (context, url) => Image.asset(
                        'assets/images/menu/buffering_img.jpg',
                        fit: BoxFit.cover,
                      ),
                  errorWidget:
                      (context, url, error) => Center(child: Icon(Icons.error)),
                ),
                // UI elements on top of the image
                Column(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    name: widget.item,
                                                    size: _selectedSize,
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
              ],
            ),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}

class BestSeller extends StatelessWidget {
  late final String text;
  late final String image;
  BestSeller(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(200),
          ),
          child: GestureDetector(
            onTap: () {
              // Handle tap interaction (for example, navigating to another page)
            },
            child: AnimatedScale(
              scale: 1.05, // Slightly zooms in when tapping
              duration: Duration(milliseconds: 200),
              child: Image.asset(
                image,
                width: 99,
                height: 99,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
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

class ProfilePopupCard extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String UID;

  ProfilePopupCard(this.name, this.phone, this.email, this.UID);

  @override
  State<ProfilePopupCard> createState() => _ProfilePopupCardState();
}

class _ProfilePopupCardState extends State<ProfilePopupCard> {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
  }

  void updateProfile() async {
    try {
      await _firestore.collection('customers').doc(widget.UID).set({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
      }, SetOptions(merge: true));

      setState(() {
        isEditing = false;
      });
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: 320,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.brown.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AnimatedOpacity(
                opacity: isEditing ? 0.5 : 1.0, // Adjust opacity when editing
                duration: Duration(milliseconds: 200),
                child: Image.asset('assets/images/coffee_cup.png', height: 50),
              ),
              SizedBox(width: 12),
              Expanded(
                child:
                    isEditing
                        ? TextField(
                          controller: nameController,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        )
                        : Text(
                          nameController.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (isEditing) {
                    updateProfile();
                  } else {
                    setState(() {
                      isEditing = true;
                    });
                  }
                },
                icon: Icon(
                  isEditing ? Icons.save : Icons.edit,
                  size: 16,
                  color: Colors.white,
                ),
                label: Text(
                  isEditing ? 'Save' : 'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade600,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  textStyle: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
                ),
              ),
            ],
          ),
          Divider(color: Colors.brown.shade200, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phone No',
                style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
              ),
              isEditing
                  ? SizedBox(
                    width: 130,
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        prefixText: '+91 ',
                      ),
                    ),
                  )
                  : Text(
                    '+91 ${phoneController.text}',
                    style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                  ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email',
                style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
              ),
              Flexible(
                child: Text(
                  widget.email,
                  style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('UID', style: TextStyle(fontSize: 16, fontFamily: 'Kanit')),
              Flexible(
                child: Text(
                  '${widget.UID.substring(0, 10)}xxxxx',
                  style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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

// child: Column(
//   children: [
//     Container(
//       width: double.infinity,
//       height: 45,
//       margin: EdgeInsets.symmetric(horizontal: 8),
//       decoration: const BoxDecoration(
//         color: Color(0xff1E130E),
//       ),
//       child: TextField(
//         controller: searchController,
//         onChanged: (value) {
//           setState(() {
//             filteredSuggestions =
//                 allItemNames
//                     .where(
//                       (item) => item
//                           .toLowerCase()
//                           .contains(value.toLowerCase()),
//                     )
//                     .toList();
//             showSuggestions = value.isNotEmpty;
//           });
//         },
//         onTapOutside: (_) {
//           setState(() {
//             showSuggestions = false;
//           });
//         },
//         style: TextStyle(color: Colors.black),
//         decoration: const InputDecoration(
//           prefixIcon: Icon(Icons.search),
//           hintText: 'Get your fav Nescafe cup now...',
//           hintStyle: TextStyle(
//             fontStyle: FontStyle.italic,
//             fontWeight: FontWeight.w300,
//             color: Color(0xff8D8D8D),
//           ),
//           filled: true,
//           fillColor: Color(0xffE6DCDB),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(32.0),
//             ),
//           ),
//         ),
//       ),
//     ),
//     if (showSuggestions && filteredSuggestions.isNotEmpty)
//       Container(
//         margin: EdgeInsets.symmetric(horizontal: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         constraints: BoxConstraints(maxHeight: 200),
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: filteredSuggestions.length,
//           itemBuilder: (context, i) {
//             return ListTile(
//               title: Text(
//                 filteredSuggestions[i],
//                 style: TextStyle(
//                   fontFamily: 'Kanit',
//                   color: Colors.black87,
//                 ),
//               ),
//               onTap: () {
//                 String selectedItem =
//                     filteredSuggestions[i];
//                 int sectionIndex = dataProvider
//                     .findSectionIndexByItem(selectedItem);
//
//                 if (sectionIndex != -1) {
//                   scrollToSection(sectionIndex + 6);
//                   print('Selected Item: $selectedItem');
//                   print('Section Index: $sectionIndex');
//
//                   setState(() {
//                     searchController.text =
//                         selectedItem; // ✅ Show in search bar
//                     searchController.selection =
//                         TextSelection.fromPosition(
//                           TextPosition(
//                             offset:
//                                 searchController
//                                     .text
//                                     .length,
//                           ),
//                         );
//                     showSuggestions = false;
//                   });
//                 }
//               },
//             );
//           },
//         ),
//       ),
//   ],
// ),
