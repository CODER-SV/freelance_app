import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:nescafe_flutter/Screens/loading_screen.dart';
import 'package:nescafe_flutter/Screens/order_confirmation_screen.dart';
import 'package:nescafe_flutter/Screens/recent_order.dart';
import 'package:nescafe_flutter/provider/cart_provider.dart';
import 'package:nescafe_flutter/provider/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:nescafe_flutter/Screens/cart_screen.dart';
import 'package:nescafe_flutter/Screens/customisation_screen.dart';
import 'package:nescafe_flutter/Screens/home_screen.dart';
import 'package:nescafe_flutter/Screens/sigin_screens.dart';
import 'package:nescafe_flutter/Screens/splash_screen.dart';
import 'package:nescafe_flutter/Screens/welcome_screen_first.dart';
import 'package:nescafe_flutter/Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Kanit',
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Color(0xffFAF4F2),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xff1E130E),
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: WelcomeScreenFirst.id,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case LoadingScreen.id:
              return customPageRoute(LoadingScreen());
            case SplashScreen.id:
              return customPageRoute(SplashScreen());
            case WelcomeScreenFirst.id:
              return customPageRoute(WelcomeScreenFirst());
            case LoginScreen.id:
              return customPageRoute(LoginScreen());
            case SiginScreens.id:
              return customPageRoute(SiginScreens());
            case HomeScreen.id:
              return customPageRoute(HomeScreen());
            case CustomisationScreen.id:
              return customPageRoute(CustomisationScreen());
            case CartScreen.id:
              return customPageRoute(CartScreen());
            case RecentOrder.id:
              return customPageRoute(RecentOrder());
            case OrderConfirmationScreen.id:
              final args = settings.arguments as Map<String, dynamic>;
              final orderId = args['orderId'];
              return customPageRoute(OrderConfirmationScreen(orderId: orderId));
            default:
              return MaterialPageRoute(
                builder:
                    (_) => Scaffold(
                      body: Center(child: Text('404: Page not found')),
                    ),
              );
          }
        },
      ),
    );
  }
}

PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}
