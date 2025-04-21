import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../Constants.dart';
import '../provider/data_provider.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  final List<String> loadingTexts = [
    'Food tastes better when eaten with the family :)',
    'Wait, directing to the next page...',
    'Drink some water...',
    'Your dog is hungry too...',
  ];

  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Timer? _textTimer;

  @override
  void initState() {
    super.initState();

    // Animation for fade transition
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Start the text cycle (show different loading texts)
    _startTextCycle();

    // Begin loading data after the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _startTextCycle() {
    _fadeController.forward();
    _textTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fadeController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _currentIndex = (_currentIndex + 1) % loadingTexts.length;
        });
        _fadeController.forward();
      });
    });
  }

  Future<void> _loadData() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    try {
      // Start fetching data
      await Future.wait([
        dataProvider.fetchMenuData(),
        dataProvider.fetchOrders(),
      ]);
    } catch (e) {
      debugPrint('Loading error: $e');
    }

    if (!mounted) return;
    _textTimer?.cancel();

    // After the data is fetched, transition to the HomeScreen
    _navigateToHome();
  }

  // Function to navigate to the HomeScreen with a smooth transition
  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Start off-screen from the bottom
          const end = Offset.zero; // Move to the center
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation to show a loading animation
            Lottie.asset(
              'assets/animations/loading.json',
              fit: BoxFit.contain,
              height: 200,
              repeat: true,
            ),
            const SizedBox(height: 40),
            // Fade transition for loading text
            FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  loadingTexts[_currentIndex],
                  style: loadingTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
